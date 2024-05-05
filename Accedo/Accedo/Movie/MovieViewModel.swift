import Foundation
import AccedoREST

/// Starting page number.
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
    
    /// Object responsible for proxy network calls for fetching genres list.
    private let networkProxy: any RESTMovieNetworkProxy
    
    /// Object responsible for handle interactions between database and application.
    private let repository: MovieRepositoryInterface
    
    /// List of movies.
    @Published private(set) var movies: [Movie] = []
    
    /// Current state of module.
    @Published private(set) var state: State = .wholeViewLoading
    
    /// Optional error that will be consumed to show an `Alert` to user.
    @Published var error: (Error)?

    private var currentPage: UInt16 = startPaginationPageNumber

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

            state = .list
        }
    }

    func requestForMoreMovies(movieId: Int) {
        guard let lastMovie = movies.last,
              lastMovie.id == movieId else {
            // no-op
            return
        }

        Task {
            state = .loadingMoreItems(page: currentPage)

            try await upsertMovies()

            state = .list
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
        let fetchResult = try await self.networkProxy.fetchMovies(for: currentPage)

        switch fetchResult {
            case let .success(response):
                try await repository.upsertMovies(response.movies)
                currentPage += 1

            case let .failure(error):
                throw error
        }
    }
}
