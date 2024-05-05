import Foundation

protocol RESTAuthorizationProvider {
    func getAuthorization() throws -> REST.Authorization
}

extension REST {
    public typealias Authorization = String
    public typealias AuthorizationProvider = () -> Authorization

    struct AccessTokenProvider: RESTAuthorizationProvider {
        private let accessTokenResolver: (() throws -> Authorization)

        init(accessToken: @escaping (() throws -> Authorization)) {
            self.accessTokenResolver = accessToken
        }

        func getAuthorization() throws -> REST.Authorization {
            try accessTokenResolver()
        }
    }
}
