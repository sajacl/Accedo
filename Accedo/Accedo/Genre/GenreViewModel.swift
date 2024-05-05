import Foundation
import SwiftUI
import AccedoREST

@MainActor
public final class GenreViewModel: ObservableObject {
    private let networkProxy: any RESTGenreNetworkProxy

    private let repository: GenreRepositoryInterface

    @Published private(set) var genres: [Genre] = []

    @Published private(set) var isLoading = false

    init(
        networkProxy: any RESTGenreNetworkProxy,
        repository: any GenreRepositoryInterface
    ) {
        self.networkProxy = networkProxy
        self.repository = repository
    }

    func viewDidAppear() {
        Task {
            isLoading = true

            await fetchAndUpdateGenreList()

            isLoading = false
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
            // Show error
        }
    }

    private func getGenres() async throws -> [Genre] {
        try await repository.getMovies()
    }

    private func updateGenres() async throws {
        let fetchResult = try await self.networkProxy.fetchGenres()

        switch fetchResult {
            case let .success(response):
                try await repository.upsertMovies(response.genres)

            case let .failure(error):
                throw error
        }
    }
}
