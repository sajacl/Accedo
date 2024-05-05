import Foundation

/// HTTP method
struct HTTPMethod: RawRepresentable {
    static let get = HTTPMethod(rawValue: "GET")
    static let post = HTTPMethod(rawValue: "POST")

    let rawValue: String
    init(rawValue: String) {
        self.rawValue = rawValue.uppercased()
    }
}

/// HTTP status
struct HTTPStatus: RawRepresentable, Equatable {
    static let notModified = HTTPStatus(rawValue: 304)
    static let badRequest = HTTPStatus(rawValue: 400)
    static let notFound = HTTPStatus(rawValue: 404)

    static func isSuccess(_ code: Int) -> Bool {
        (200..<300) ~= code
    }

    let rawValue: Int

    init(rawValue: Int) {
        self.rawValue = rawValue
    }

    var isSuccess: Bool {
        Self.isSuccess(rawValue)
    }
}

/// HTTP headers
enum HTTPHeader {
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let apiKey = "api-key"
}
