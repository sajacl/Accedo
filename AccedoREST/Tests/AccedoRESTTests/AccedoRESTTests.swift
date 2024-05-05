import XCTest
@testable import AccedoREST

final class AccedoRESTTests: XCTestCase {
    func testFetchGenres() {
        let networkResultPromise = expectation(description: "Send a request to server and retrieve data.")

        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: REST.AccessTokenProvider(accessToken: { "6f83e26e82a37507bf29b27ff511f452" }),
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

        let networkOperation = REST.NetworkOperationDispatcher(
            name: "hand-shake-test",
            requestHandler: requestHandler,
            responseHandler: responseHandler,
            resultCompletionHandler: { result in
                do {
                    let genres = try result.get()

                    XCTAssertNotNil(genres.genres)
                    networkResultPromise.fulfill()
                } catch {
                    XCTFail(error.localizedDescription)
                }
            }
        )

        networkOperation.start()

        wait(for: [networkResultPromise], timeout: 10)
    }

    func testFetchGenresAsync() async throws {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: REST.AccessTokenProvider(accessToken: { "6f83e26e82a37507bf29b27ff511f452" }),
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

        let networkOperation = REST.SwiftConcurrencyNetworkDispatcher(
            name: "hand-shake-test",
            requestHandler: requestHandler,
            responseHandler: responseHandler
        )

        let result = try await networkOperation.start()

        let genres = try result.get()

        XCTAssertNotNil(genres.genres)
    }

    func testFetchMovies() throws {
        let networkResultPromise = expectation(description: "Send a request to server and retrieve data.")

        let movieNetworkProxy = MovieNetworkProxy(authorizationProvider: REST.AccessTokenProvider(accessToken: { "6f83e26e82a37507bf29b27ff511f452" }))

        movieNetworkProxy.fetchMovies { result in
            do {
                let genres = try result.get()

                XCTAssertNotNil(genres.movies)
                networkResultPromise.fulfill()
            } catch {
                XCTFail(error.localizedDescription)
            }
        }

        wait(for: [networkResultPromise], timeout: 10)
    }

    func testFetchKeywords() async throws {
        let requestHandler = REST.AnyRequestHandler { endpoint in
            let requestFactory = REST.RequestFactory.default(
                with: REST.AccessTokenProvider(accessToken: { "6f83e26e82a37507bf29b27ff511f452" }),
                bodyEncoder: REST.Coding.makeJSONEncoder()
            )

            return try requestFactory.createRequest(
                for: .get,
                pathTemplate: "/3/search/keyword",
                additionalQueryItems: [URLQueryItem(name: "query", value: "Action")]
            )
        }

        let responseHandler = REST.defaultResponseHandler(
            decoding: KeywordsDecodableModel.self,
            with: REST.Coding.makeJSONDecoder()
        )

        let networkOperation = REST.SwiftConcurrencyNetworkDispatcher(
            name: "hand-shake-test",
            requestHandler: requestHandler,
            responseHandler: responseHandler
        )

        let result = try await networkOperation.start()

        let genres = try result.get()

        XCTAssertNotNil(genres.results)
    }
}

// MARK: - Welcome
struct KeywordsDecodableModel: Codable {
    let page: Int?
    let results: [KeywordsResultDecodableModel]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct KeywordsResultDecodableModel: Codable {
    let id: Int?
    let name: String?
}
