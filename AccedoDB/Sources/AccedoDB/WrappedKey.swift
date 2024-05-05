import Foundation

extension Cache {
    final class WrappedKey: NSObject {
        let key: Key

        init(_ _key: Key) {
            key = _key
        }

        override var hash: Int {
            return key.hashValue
        }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}
