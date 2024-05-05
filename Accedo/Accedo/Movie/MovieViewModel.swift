import Foundation
import AccedoREST

private let startPaginationPageNumber: UInt16 = 1

@MainActor
public final class MovieViewModel: ObservableObject {
    /// Light weight state machine.
    enum State {
        case wholeViewLoading

        case empty

        case list

        case loadingMoreItems(page: UInt16)
    }
    
    /// <#Description#>
    private let networkProxy: any RESTMovieNetworkProxy
    
    /// <#Description#>
    private let repository: MovieRepositoryInterface
    
    /// <#Description#>
    @Published private(set) var movies: [Movie] = []
    
    /// <#Description#>
    @Published private(set) var state: State = .wholeViewLoading
    
    /// <#Description#>
    @Published var error: (Error)?

    init(
        networkProxy: any RESTMovieNetworkProxy,
        repository: any MovieRepositoryInterface
    ) {
        self.networkProxy = networkProxy
        self.repository = repository
    }

    func viewDidAppear() {
        Task {
            state = .wholeViewLoading

            await fetchAndUpdateMovieList()

            state = .wholeViewLoading
        }
    }

    private func fetchAndUpdateMovieList() async {
        do {
            let movies = try await getMovies()

            guard !movies.isEmpty else {
                try await upsertMovies()

                let movies = try await getMovies()
                self.movies = movies
                return
            }

            self.movies = movies
        } catch {
            self.error = error
        }
    }

    private func getMovies() async throws -> [Movie] {
        try await repository.getMovies()
    }

    private func upsertMovies() async throws {
        let fetchResult = try await self.networkProxy.fetchMovies()

        switch fetchResult {
            case let .success(response):
                try await repository.upsertMovies(response.movies)

            case let .failure(error):
                throw error
        }
    }
}
