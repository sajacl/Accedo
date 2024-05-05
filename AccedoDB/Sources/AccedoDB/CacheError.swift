import Foundation

private let lifeTimeDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return dateFormatter
}()

extension Cache {
    public enum Error: LocalizedError, @unchecked Sendable {
        case missingValue(forKey: Key)

        case expired(objectOriginalLifetime: Date)

        nonisolated
        public var errorDescription: String? {
            switch self {
                case let .missingValue(key):
                    return "Missing object for key: \(key)"

                case let .expired(objectOriginalLifetime):
                    let formattedDate: String

                    if #available(iOS 15.0, *) {
                        formattedDate = objectOriginalLifetime.formatted(date: .complete, time: .complete)
                    } else {
                        formattedDate = lifeTimeDateFormatter.string(from: objectOriginalLifetime)
                    }

                    return "Object has expired at \(formattedDate)"
            }
        }
    }
}
