import Foundation

extension REST {
    final class RequestFactory {
        let hostname: String
        let authorizationProvider: RESTAuthorizationProvider
        let networkTimeout: TimeInterval
        let bodyEncoder: JSONEncoder

        class func `default`(
            with authorizationProvider: RESTAuthorizationProvider,
            bodyEncoder: JSONEncoder
        ) -> RequestFactory {
            return RequestFactory(
                hostname: apiHost,
                authorizationProvider: authorizationProvider,
                networkTimeout: defaultAPINetworkTimeout,
                bodyEncoder: bodyEncoder
            )
        }

        init(
            hostname: String,
            authorizationProvider: RESTAuthorizationProvider,
            networkTimeout: TimeInterval,
            bodyEncoder: JSONEncoder
        ) {
            self.hostname = hostname
            self.authorizationProvider = authorizationProvider
            self.networkTimeout = networkTimeout
            self.bodyEncoder = bodyEncoder
        }

        func createRequest(
            for method: HTTPMethod,
            pathTemplate: URLPathTemplate,
            additionalQueryItems: [URLQueryItem] = []
        ) throws -> REST.Request {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = hostname

            let authorization: REST.Authorization = try authorizationProvider.getAuthorization()

            var queries = [
                URLQueryItem(name: HTTPHeader.apiKey, value: authorization),
                URLQueryItem(name: HTTPHeader.language, value: REST.language)
            ]

            if !additionalQueryItems.isEmpty {
                queries.append(contentsOf: additionalQueryItems)
            }

            urlComponents.queryItems = queries

            let pathString = try pathTemplate.pathString()

            guard let componentsFullURL = urlComponents.url else {
                throw URLError(.badURL)
            }

            let requestURL = componentsFullURL.appendingPathComponent(pathString)

            var request = URLRequest(
                url: requestURL,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: networkTimeout
            )

            request.httpShouldHandleCookies = false
            request.addValue("application/json", forHTTPHeaderField: HTTPHeader.contentType)
            request.httpMethod = method.rawValue

            return REST.Request(
                urlRequest: request,
                pathTemplate: pathTemplate
            )
        }
    }

    struct URLPathTemplate: ExpressibleByStringLiteral {
        enum Component {
            case literal(String)
            case placeholder(String)
        }

        enum Error: LocalizedError {
            /// Replacement value is not provided for placeholder.
            case noReplacement(_ name: String)

            /// Failure to perecent encode replacement value.
            case percentEncoding

            public var errorDescription: String? {
                switch self {
                    case let .noReplacement(placeholder):
                        return "Replacement is not provided for \(placeholder)."

                    case .percentEncoding:
                        return "Failed to percent encode replacement value."
                }
            }
        }

        private var components: [Component]
        private var replacements = [String: String]()

        init(stringLiteral value: StringLiteralType) {
            let slashCharset = CharacterSet(charactersIn: "/")

            components = value.split(separator: "/").map { subpath -> Component in
                if subpath.hasPrefix("{"), subpath.hasSuffix("}") {
                    let name = String(subpath.dropFirst().dropLast())

                    return .placeholder(name)
                } else {
                    return .literal(
                        subpath.trimmingCharacters(in: slashCharset)
                    )
                }
            }
        }

        private init(components: [Component]) {
            self.components = components
        }

        var templateString: String {
            var combinedString = ""

            for component in components {
                combinedString += "/"

                switch component {
                    case let .literal(string):
                        combinedString += string
                    case let .placeholder(name):
                        combinedString += "{\(name)}"
                }
            }

            return combinedString
        }

        func pathString() throws -> String {
            var combinedPath = ""

            for component in components {
                combinedPath += "/"

                switch component {
                    case let .literal(string):
                        combinedPath += string

                    case let .placeholder(name):
                        if let string = replacements[name] {
                            combinedPath += string
                        } else {
                            throw Error.noReplacement(name)
                        }
                }
            }

            return combinedPath
        }

        static func + (lhs: URLPathTemplate, rhs: URLPathTemplate) -> URLPathTemplate {
            return URLPathTemplate(components: lhs.components + rhs.components)
        }
    }
}
