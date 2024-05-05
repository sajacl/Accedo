import Foundation
import AccedoDB
import struct AccedoREST.GenreAPIResponse
import struct AccedoREST.GenreDecodableModel

protocol GenreRepositoryInterface {
    @DatabaseActor
    func getMovies() throws -> [Genre]

    @DatabaseActor
    func upsertMovies(_ decodedGenres: [GenreDecodableModel]) throws
}

final class GenreRepository: GenreRepositoryInterface {
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
}

struct Genre: Hashable, Identifiable {
    let id: Int
    let name: String

    fileprivate init(from decodableModel: GenreDecodableModel) {
        id = decodableModel.id
        name = decodableModel.name ?? "-Empty name-"
    }
}
