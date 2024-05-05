import Foundation

/// Movie list url path.
private let movieURLPath = "/3/discover/movie"

/// Tag that will be used for naming network operation.
private let tag = "fetch-movies"

public protocol RESTMovieNetworkProxy {
    @available(iOS 13.0, *)
    func fetchMovies(for page: UInt16) async throws -> Result<MoviesAPIResponse, Error>

    func fetchMovies(
        for page: UInt16,
        with completionHandler: @escaping (Result<MoviesAPIResponse, Swift.Error>) -> Void
    ) -> Cancellable
}

extension REST {
    /// Object responsible for proxy network calls for fetching movies list.
    public final class MovieNetworkProxy: NetworkProxy, RESTMovieNetworkProxy {
        private let genreId: Int

        public init(
            genreId: Int,
            authorizationProvider: @autoclosure @escaping () throws -> REST.Authorization
        ) {
            self.genreId = genreId

            super.init(authorizationProvider: try authorizationProvider())
        }

        public init(genreId: Int, authorizationProvider: RESTAuthorizationProvider) {
            self.genreId = genreId

            super.init(authorizationProvider: authorizationProvider)
        }
    }
}

// Swift concurrency version.
@available(iOS 13.0, *)
extension REST.MovieNetworkProxy {
    public func fetchMovies(for page: UInt16) async throws -> Result<MoviesAPIResponse, Swift.Error> {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: REST.URLPathTemplate(stringLiteral: movieURLPath),
                additionalQueryItems: [URLQueryItem(name: "page", value: "\(page)")]
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
        for page: UInt16,
        with completionHandler: @escaping (Result<MoviesAPIResponse, Swift.Error>) -> Void
    ) -> Cancellable {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: REST.URLPathTemplate(stringLiteral: movieURLPath),
                additionalQueryItems: [URLQueryItem(name: "page", value: "\(page)")]
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

        return fetchMoviesNetworkOperation
    }
}
