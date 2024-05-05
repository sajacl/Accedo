import Foundation

extension REST {
    static func makeURLSession() -> URLSession {
        let sessionConfiguration = URLSessionConfiguration.ephemeral

        let session = URLSession(
            configuration: sessionConfiguration,
            delegate: nil,
            delegateQueue: nil
        )

        return session
    }
}
