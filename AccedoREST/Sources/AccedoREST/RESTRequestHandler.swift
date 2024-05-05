import Foundation

protocol RESTRequestHandler {
    func createURLRequest(
        host: String
    ) throws -> REST.Request
}

extension REST {
    struct Request {
        public var urlRequest: URLRequest
        public var pathTemplate: URLPathTemplate
    }

    typealias AnyHost = String

    final class AnyRequestHandler: RESTRequestHandler {
        private let _createURLRequest: (AnyHost) throws -> REST.Request

        init(createURLRequest: @escaping (AnyHost) throws -> REST.Request) {
            _createURLRequest = { endpoint in
                return try createURLRequest(endpoint)
            }
        }

        func createURLRequest(
            host: AnyHost
        ) throws -> REST.Request {
            return try _createURLRequest(host)
        }
    }
}
