import Foundation

/// Movie list url path.
private let movieURLPath = "/3/discover/movie"

/// Tag that will be used for naming network operation.
private let tag = "fetch-movies"

extension REST {
    /// Object responsible for proxy network calls for fetching movies list.
    public final class MovieNetworkProxy: NetworkProxy {}
}

// Swift concurrency version.
@available(iOS 13.0, *)
extension REST.MovieNetworkProxy {
    public func fetchMovies() async throws -> Result<MoviesAPIResponse, Swift.Error> {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: REST.URLPathTemplate(stringLiteral: movieURLPath)
            )
        }

        let responseHandler = REST.defaultResponseHandler(
            decoding: MoviesAPIResponse.self,
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
extension REST.MovieNetworkProxy {
    public func fetchMovies(
        with completionHandler: @escaping (Result<MoviesAPIResponse, Swift.Error>) -> Void
    ) {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: REST.URLPathTemplate(stringLiteral: movieURLPath)
            )
        }

        let responseHandler = REST.defaultResponseHandler(
            decoding: MoviesAPIResponse.self,
            with: REST.Coding.makeJSONDecoder()
        )

        let fetchMoviesNetworkOperation = REST.NetworkOperationDispatcher(
            name: tag + "-closure",
            requestHandler: requestHandler,
            responseHandler: responseHandler,
            resultCompletionHandler: completionHandler
        )

        networkOperationQueue.addOperation(fetchMoviesNetworkOperation)
    }
}
