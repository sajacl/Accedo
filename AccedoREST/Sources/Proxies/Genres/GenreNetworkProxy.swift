import Foundation

/// Genre list url path.
private let genreURLPath = "/3/genre/movie/list"

/// Tag that will be used for naming network operation.
private let tag = "fetch-genre"

public protocol RESTGenreNetworkProxy {
    @available(iOS 13.0, *)
    func fetchGenres() async throws -> Result<GenreAPIResponse, Error>

    func fetchGenres(
        with completionHandler: @escaping (Result<GenreAPIResponse, Error>) -> Void
    )
}

extension REST {
    /// Object responsible for proxy network calls for fetching genres list.
    public final class GenreNetworkProxy: NetworkProxy, RESTGenreNetworkProxy {}
}

// Swift concurrency version.
@available(iOS 13.0, *)
extension REST.GenreNetworkProxy {
    public func fetchGenres() async throws -> Result<GenreAPIResponse, Error> {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: REST.URLPathTemplate(stringLiteral: genreURLPath)
            )
        }

        let responseHandler = REST.defaultResponseHandler(
            decoding: GenreAPIResponse.self,
            with: REST.Coding.makeJSONDecoder()
        )

        let networkOperation = REST.SwiftConcurrencyNetworkDispatcher(
            name: tag + "-async",
            requestHandler: requestHandler,
            responseHandler: responseHandler
        )

        return try await networkOperation.start()
    }
}

// Closure version.
extension REST.GenreNetworkProxy {
    public func fetchGenres(
        with completionHandler: @escaping (Result<GenreAPIResponse, Error>) -> Void
    ) {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: REST.URLPathTemplate(stringLiteral: genreURLPath)
            )
        }

        let responseHandler = REST.defaultResponseHandler(
            decoding: GenreAPIResponse.self,
            with: REST.Coding.makeJSONDecoder()
        )

        let fetchGenresNetworkOperation = REST.NetworkOperationDispatcher(
            name: tag + "-closure",
            requestHandler: requestHandler,
            responseHandler: responseHandler,
            resultCompletionHandler: completionHandler
        )

        networkOperationQueue.addOperation(fetchGenresNetworkOperation)
    }
}
