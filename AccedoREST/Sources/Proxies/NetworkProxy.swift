import Foundation

public class NetworkProxy {
    internal let authorizationProvider: RESTAuthorizationProvider

    /// Serial queue for using operations and completion handler.
    internal lazy var networkOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    public init(authorizationProvider: @autoclosure @escaping () throws -> REST.Authorization) {
        self.authorizationProvider = REST.AccessTokenProvider(accessToken: authorizationProvider)
    }

    public init(authorizationProvider: RESTAuthorizationProvider) {
        self.authorizationProvider = authorizationProvider
    }
}
