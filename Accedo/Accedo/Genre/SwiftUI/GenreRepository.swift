import Foundation
import AccedoDB
import struct AccedoREST.GenreAPIResponse
import struct AccedoREST.GenreDecodableModel

/// Cache store name.
private let repositoryCacheName = "GenreCache"

protocol GenreRepositoryInterface {
    @DatabaseActor
    func getGenres() throws -> [Genre]

    @DatabaseActor
    func upsertGenres(_ decodedGenres: [GenreDecodableModel]) throws
}

final class GenreRepository: GenreRepositoryInterface {
    private let cache: Cache<Int, Genre>

    init() {
        cache = Self.tryToReadCacheFromStore()
    }

    private static func tryToReadCacheFromStore(
        fileManager: FileManager = FileManager.default,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Cache<Int, Genre> {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(repositoryCacheName + ".cache")

        do {
            let data = try Data(contentsOf: fileURL, options: .uncached)

            let cacheBox = try decoder.decode(Cache<Int, Genre>.self, from: data)

            return cacheBox
        } catch {
            return Cache(name: repositoryCacheName)
        }
    }

    @DatabaseActor
    func getGenres() throws -> [Genre] {
        try cache.allValues()
    }

    /// Adds or updates movies with the same id.
    /// - Warning: This method has small overhead (O(n) * 2, since for code clarity it uses two iteration,
    /// One for decoding and one for adding/updating in cache.
    @DatabaseActor
    func upsertGenres(_ decodedGenres: [GenreDecodableModel]) throws {
        let mappedGenres = decodedGenres.map(Genre.init(from:))

        mappedGenres.forEach { genre in
            cache.upsert(genre, forKey: genre.id)
        }

        Task.detached(priority: .background) { [weak self] in
            try self?.cache.saveToDisk()
        }
    }
}

struct Genre: Hashable, Identifiable, Codable {
    let id: Int
    let name: String

    fileprivate init(from decodableModel: GenreDecodableModel) {
        id = decodableModel.id
        name = decodableModel.name ?? "-Empty name-"
    }
}
