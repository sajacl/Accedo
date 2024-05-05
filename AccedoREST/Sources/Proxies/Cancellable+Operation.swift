import Foundation

public protocol Cancellable {
    func cancel()
}

extension Operation: Cancellable {}
