import Foundation

/// Genre list url path.
private let genreURLPath = "/3/genre/movie/list"

/// Tag that will be used for naming network operation.
private let tag = "fetch-genre"

public final class GenreNetworkProxy {
    private let authorizationProvider: RESTAuthorizationProvider

    /// Serial queue for using operations and completion handler.
    private lazy var networkOperationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()

    public init(authorizationProvider: @autoclosure @escaping () throws -> REST.Authorization) {
        self.authorizationProvider = REST.AccessTokenProvider(accessToken: authorizationProvider)
    }

    public init(authorizationProvider: RESTAuthorizationProvider) {
        self.authorizationProvider = authorizationProvider
    }

    @available(iOS 13.0, *)
    public func fetchGenres() async throws -> Result<GenresDecodableModel, Error> {
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
            decoding: GenresDecodableModel.self,
            with: REST.Coding.makeJSONDecoder()
        )

        let networkOperation = REST.SwiftConcurrencyNetworkDispatcher(
            name: tag + "-async",
            requestHandler: requestHandler,
            responseHandler: responseHandler
        )

        return try await networkOperation.start()
    }

    public func fetchGenres(
        completionHandler: @escaping (Result<GenresDecodableModel, Error>) -> Void
    ) {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: self.authorizationProvider,
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: "/3/genre/movie/list",
                additionalQueryItems: [URLQueryItem(name: "query", value: "Action")]
            )
        }

        let responseHandler = REST.defaultResponseHandler(
            decoding: GenresDecodableModel.self,
            with: REST.Coding.makeJSONDecoder()
        )

        let fetchGenreNetworkOperation = REST.NetworkOperationDispatcher(
            name: "hand-shake-test",
            requestHandler: requestHandler,
            responseHandler: responseHandler,
            resultCompletionHandler: completionHandler
        )

        networkOperationQueue.addOperation(fetchGenreNetworkOperation)
    }
}
