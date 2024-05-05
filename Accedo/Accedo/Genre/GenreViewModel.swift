import Foundation
import SwiftUI
import AccedoREST

@MainActor
public final class GenreViewModel: ObservableObject {
    /// Light weight state machine.
    enum State {
        case loading

        case empty

        case list
    }
    
    /// Object responsible for proxy network calls for fetching genres list.
    private let networkProxy: any RESTGenreNetworkProxy
    
    /// Object responsible for handle interactions between database and application.
    private let repository: GenreRepositoryInterface
    
    /// List of genres.
    @Published private(set) var genres: [Genre] = []
    
    /// Current state of module.
    @Published private(set) var state: State = .loading
    
    /// Optional error that will be consumed to show an `Alert` to user.
    @Published var error: (Error)?

    init(
        networkProxy: any RESTGenreNetworkProxy,
        repository: any GenreRepositoryInterface
    ) {
        self.networkProxy = networkProxy
        self.repository = repository
    }

    func viewDidAppear() {
        Task {
            state = .loading

            await fetchAndUpdateGenreList()

            if genres.isEmpty {
                state = .empty
            } else {
                state = .list
            }
        }
    }

    private func fetchAndUpdateGenreList() async {
        do {
            let genres = try await getGenres()

            guard !genres.isEmpty else {
                try await updateGenres()

                let genres = try await getGenres()
                self.genres = genres
                return
            }

            self.genres = genres
        } catch {
            self.error = error
        }
    }

    private func getGenres() async throws -> [Genre] {
        try await repository.getGenres()
    }

    private func updateGenres() async throws {
        let fetchResult = try await self.networkProxy.fetchGenres()

        switch fetchResult {
            case let .success(response):
                try await repository.upsertGenres(response.genres)

            case let .failure(error):
                throw error
        }
    }

    func createGenreDetail(for genre: Genre) -> some View {
        MovieWireframe.create(
            with: ProcessInfo.processInfo.environment["api_key"],
            for: genre
        )
    }
}
