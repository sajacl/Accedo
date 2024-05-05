import XCTest
@testable import AccedoDB

private let cacheName = "Test"

final class AccedoDBSmokeTests: XCTestCase {
    private let mockKey: Int = 1
    
    private let mockValue = "#VALUE#"

    @DatabaseActor
    func testWriteToCache() throws {
        let cache = Cache<Int, String>(name: cacheName)

        cache.upsert(mockValue, forKey: mockKey)

        XCTAssertNotNil(try? cache.value(forKey: mockKey))

        cache.removeValue(forKey: mockKey)
    }

    @DatabaseActor
    func testWriteCacheToFile() throws {
        let cache = Cache<Int, String>(name: cacheName)

        cache.upsert(mockValue, forKey: mockKey)

        XCTAssertNotNil(try? cache.value(forKey: mockKey))

        XCTAssertNoThrow(try cache.saveToDisk())
    }

    @DatabaseActor
    func testWriteCacheToFile_RawRetrieve() throws {
        let cache = Cache<Int, String>(name: cacheName)

        cache.upsert(mockValue, forKey: mockKey)

        XCTAssertNotNil(try? cache.value(forKey: mockKey))

        XCTAssertNoThrow(try cache.saveToDisk())

        let fileManager = FileManager.default

        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(cacheName + ".cache")

        let data = try Data(contentsOf: fileURL, options: .uncached)
        let rawCache = String(data: data, encoding: .utf8)

        XCTAssertNotNil(rawCache)
        XCTAssertEqual(rawCache?.isEmpty, false)
    }

    @DatabaseActor
    func testWriteCacheToFile_CodableRetrieve() throws {
        let cache = Cache<Int, String>(name: cacheName)

        cache.upsert(mockValue, forKey: mockKey)

        XCTAssertNotNil(try? cache.value(forKey: mockKey))

        XCTAssertNoThrow(try cache.saveToDisk())

        let fileManager = FileManager.default

        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(cacheName + ".cache")

        let data = try Data(contentsOf: fileURL, options: .uncached)

        let cacheBox = try JSONDecoder().decode(Cache<Int, String>.self, from: data)

        XCTAssertNotNil(cacheBox)

        XCTAssertNoThrow(try cacheBox.value(forKey: mockKey))
    }
}
