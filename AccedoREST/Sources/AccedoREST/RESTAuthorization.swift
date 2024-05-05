import Foundation

public protocol RESTAuthorizationProvider {
    func getAuthorization() throws -> REST.Authorization
}

extension REST {
    public typealias Authorization = String
    public typealias AuthorizationProvider = () -> Authorization

    public struct AccessTokenProvider: RESTAuthorizationProvider {
        private let accessTokenResolver: (() throws -> Authorization)

        public init(accessToken: @escaping (() throws -> Authorization)) {
            self.accessTokenResolver = accessToken
        }

        public func getAuthorization() throws -> REST.Authorization {
            try accessTokenResolver()
        }
    }
}
