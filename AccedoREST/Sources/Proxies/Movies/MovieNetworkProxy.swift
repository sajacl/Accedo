import Foundation

/// Movie list url path.
private let movieURLPath = "/3/discover/movie"

/// Tag that will be used for naming network operation.
private let tag = "fetch-movies"

public final class MovieNetworkProxy: NetworkProxy {
    @available(iOS 13.0, *)
    public func fetchMovies() async throws -> Result<MoviesAPIResponse, Error> {
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

    public func fetchMovies(
        with completionHandler: @escaping (Result<MoviesAPIResponse, Error>) -> Void
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
