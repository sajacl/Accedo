import Foundation
import AccedoDB
import struct AccedoREST.GenreAPIResponse
import struct AccedoREST.GenreDecodableModel

final class GenreRepository {
    @DatabaseActor
    private let cache: Cache<Int, Genre> = Cache(name: "GenreCache")

    @DatabaseActor
    func getMovies() throws -> [Genre] {
        try cache.allValues()
    }

    /// Adds or updates movies with the same id.
    /// - Warning: This method has small overhead (O(n) * 2, since for code clarity it uses two iteration,
    /// One for decoding and one for adding/updating in cache.
    @DatabaseActor
    func upsertMovies(_ decodedGenres: [GenreDecodableModel]) throws {
        let mappedGenres = decodedGenres.map(Genre.init(from:))

        mappedGenres.forEach { genre in
            cache.upsert(genre, forKey: genre.id)
        }
    }

    public struct Genre: Hashable, Identifiable {
        public let id: Int
        public let name: String

        init(from decodableModel: GenreDecodableModel) {
            id = decodableModel.id
            name = decodableModel.name ?? "-Empty name-"
        }
    }
}
