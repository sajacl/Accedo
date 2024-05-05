import Foundation
import SwiftUI
import AccedoREST

@MainActor
public final class GenreViewModel: ObservableObject {
    private let networkProxy: REST.GenreNetworkProxy

    private let databaseRepository: GenreRepository

    @Published private(set) var genres: [GenreRepository.Genre] = []

    @Published private(set) var isLoading = false

    init(authorization: REST.Authorization) {
        self.networkProxy = REST.GenreNetworkProxy(authorizationProvider: authorization)
        self.databaseRepository = GenreRepository()
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

    private func getGenres() async throws -> [GenreRepository.Genre] {
        try await databaseRepository.getMovies()
    }

    private func updateGenres() async throws {
        let fetchResult = try await self.networkProxy.fetchGenres()

        switch fetchResult {
            case let .success(response):
                try await databaseRepository.upsertMovies(response.genres)

            case let .failure(error):
                throw error
        }
    }
}
