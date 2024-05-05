import Foundation
import AccedoLogging

@DatabaseActor
public final class Cache<Key: Hashable, Value> {
    /// Cache name.
    private let name: String

    /// Cache object.
    private let _cache = NSCache<WrappedKey, Entry>()

    /// Date provider.
    private let dateProvider: () -> Date
    
    /// Entry expiration life time.
    private let entryLifetime: TimeInterval
    
    /// Object responsible for tracking stored keys.
    private let keyTracker = KeyTracker()
    
    /// Encoder that will be used to store cache in file.
    private let encoder: () -> JSONEncoder

    private let logger: any Logging

    public init(
        name: String,
        dateProvider: @autoclosure @escaping () -> Date = Date.init(),
        entryLifetime: TimeInterval = 60 * 60 * 24,
        maximumEntryCount: UInt = 124,
        encoder: @escaping () -> JSONEncoder = JSONEncoder.init
    ) {
        self.name = name
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
        self.encoder = encoder

        _cache.countLimit = Int(maximumEntryCount)
        _cache.delegate = keyTracker

        if #available(iOS 14.0, *) {
            logger = OSLog.databaseLogger
        } else {
            logger = CustomLogger.databaseLogger
        }
    }
    
    /// Insert or update if available.
    /// - Warning: This method will skip existence check.
    public func upsert(_ value: Value, forKey key: Key) {
        let expirationDate = dateProvider().addingTimeInterval(entryLifetime)

        keyTracker.keys.insert(key)

        let entry = Entry(key: key, value: value, expirationDate: expirationDate)
        _cache.setObject(entry, forKey: WrappedKey(key))

        logger.notice(metadata: name, message: "Added object for key \(key)")
    }

    public func value(forKey key: Key) throws -> Value {
        guard let entry = _cache.object(forKey: WrappedKey(key)) else {
            logger.debug(metadata: name, message: "Attempt to access missing object with key \(key)")

            throw Error.missingValue(forKey: key)
        }

        guard dateProvider() < entry.expirationDate else {
            logger.debug(metadata: name, message: "Attempt to access expired object with key \(key)")

            // Discard values that have expired
            removeValue(forKey: key)

            throw Error.expired(objectOriginalLifetime: entry.expirationDate)
        }

        return entry.value
    }

    public func removeValue(forKey key: Key) {
        _cache.removeObject(forKey: WrappedKey(key))
    }
}

// MARK: Subscript
extension Cache {
    subscript(key: Key) -> Value? {
        get { return try? value(forKey: key) }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }

            upsert(value, forKey: key)
        }
    }
}

// MARK: Codable interactions
extension Cache: Codable where Key: Codable, Value: Codable {
    convenience public init(from decoder: Decoder) throws {
        self.init(name: "Decoder init")

        let container = try decoder.singleValueContainer()
        let entries = try container.decode([Entry].self)

        entries.forEach(insert)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode(keyTracker.keys.compactMap(entry))
    }
}

private extension Cache {
    func entry(forKey key: Key) throws -> Entry {
        guard let entry = _cache.object(forKey: WrappedKey(key)) else {
            logger.debug(metadata: name, message: "Attempt to access missing object with key \(key)")

            throw Error.missingValue(forKey: key)
        }

        guard dateProvider() < entry.expirationDate else {
            logger.debug(metadata: name, message: "Attempt to access expired object with key \(key)")

            removeValue(forKey: key)

            throw Error.expired(objectOriginalLifetime: entry.expirationDate)
        }

        return entry
    }

    func insert(_ entry: Entry) {
        _cache.setObject(entry, forKey: WrappedKey(entry.key))

        keyTracker.keys.insert(entry.key)
    }
}

// MARK: Disk interactions
extension Cache where Key: Codable, Value: Codable {
    public func saveToDisk(
        using fileManager: FileManager = .default
    ) throws {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")

        let _encoder = encoder()
        let data = try _encoder.encode(self)

        try data.write(to: fileURL)
    }
}
