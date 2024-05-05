import Foundation

extension REST {
    /// An error type returned by REST API classes.
    public enum Error: LocalizedError {
        /// Failure to create URL request.
        case createURLRequest(Swift.Error)

        /// Network failure.
        case network(URLError)

        /// Failure to handle response.
        case unhandledResponse(_ statusCode: Int, _ serverResponse: ServerErrorResponse?)

        /// Failure to decode server response.
        case decodeResponse(Swift.Error)

        public var errorDescription: String? {
            switch self {
                case .createURLRequest:
                    return "Failure to create URL request."

                case .network:
                    return "Network error."

                case let .unhandledResponse(statusCode, serverResponse):
                    var str = "Failure due dispatch a request to sever: HTTP/\(statusCode)."

                    guard let serverResponse else {
                        return str
                    }

                    let code = serverResponse.code
                    str += " [Error code]: \(code.rawValue)."

                    let detail = serverResponse.message
                    str += " [Message]: \(detail)"

                    return str

                case .decodeResponse:
                    return "Failure to decode response."
            }
        }

        public var underlyingError: Swift.Error? {
            switch self {
                case let .network(error):
                    return error

                case let .createURLRequest(error):
                    return error

                case let .decodeResponse(error):
                    return error

                case .unhandledResponse:
                    return nil
            }
        }

        public func compareErrorCode(_ code: ServerResponseCode) -> Bool {
            if case let .unhandledResponse(_, serverResponse) = self {
                return serverResponse?.code == code
            } else {
                return false
            }
        }
    }

    public struct ServerErrorResponse: Decodable, LocalizedError {
        public let code: ServerResponseCode
        public let message: String
        public let isSuccessful: Bool

        enum CodingKeys: String, CodingKey {
            case code = "status_code"
            case message = "status_message"
            case isSuccessful = "success"
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let _code = try container.decode(UInt32.self, forKey: .code)
            code = ServerResponseCode(rawValue: _code)

            message = try container.decode(String.self, forKey: .message)

            isSuccessful = try container.decode(Bool.self, forKey: .isSuccessful)
        }

        public var errorDescription: String? {
            "Failure with code [code: \(code.rawValue)] [message: \(message)]"
        }
    }

    public struct ServerResponseCode: RawRepresentable, ExpressibleByIntegerLiteral, Equatable {
        /// Response code that will indicate api key is not valid.
        public static let invalidAPIKey = ServerResponseCode(rawValue: 7)

        public let rawValue: UInt32

        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }

        public init(integerLiteral value: UInt32) {
            self.rawValue = value
        }
    }
}
