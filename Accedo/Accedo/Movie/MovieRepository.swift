import Foundation
import AccedoDB
import struct AccedoREST.MoviesAPIResponse
import struct AccedoREST.MovieDecodableModel

/// Cache store name.
private let repositoryCacheName = "MovieCache"

protocol MovieRepositoryInterface {
    @DatabaseActor
    func getMovies() throws -> [Movie]

    @DatabaseActor
    func upsertMovies(_ decodedMovies: [MovieDecodableModel]) throws
}

final class MovieRepository: MovieRepositoryInterface {
    private let cache: Cache<Int, Movie>

    init() {
        cache = Self.tryToReadCacheFromStore()
    }

    private static func tryToReadCacheFromStore(
        fileManager: FileManager = FileManager.default,
        decoder: JSONDecoder = JSONDecoder()
    ) -> Cache<Int, Movie> {
        let folderURLs = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )

        let fileURL = folderURLs[0].appendingPathComponent(repositoryCacheName + ".cache")

        do {
            let data = try Data(contentsOf: fileURL, options: .uncached)

            let cacheBox = try decoder.decode(Cache<Int, Movie>.self, from: data)

            return cacheBox
        } catch {
            return Cache(name: repositoryCacheName)
        }
    }

    @DatabaseActor
    func getMovies() throws -> [Movie] {
        try cache.allValues()
    }
    
    /// Adds or updates movies with the same id.
    /// - Warning: This method has small overhead (O(n) * 2, since for code clarity it uses two iteration,
    /// One for decoding and one for adding/updating in cache.
    @DatabaseActor
    func upsertMovies(_ decodedMovies: [MovieDecodableModel]) throws {
        let mappedMovies = decodedMovies.map(Movie.init(from:))

        mappedMovies.forEach { movie in
            cache.upsert(movie, forKey: movie.id)
        }

        Task.detached(priority: .background) { [weak self] in
            try self?.cache.saveToDisk()
        }
    }
}

struct Movie: Hashable, Identifiable, Codable {
    let id: Int
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate: String?
    let title: String
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    fileprivate init(from decodableModel: MovieDecodableModel) {
        id = decodableModel.id
        adult = decodableModel.adult
        backdropPath = decodableModel.backdropPath
        genreIDS = decodableModel.genreIDS ?? []
        originalLanguage = decodableModel.originalLanguage
        originalTitle = decodableModel.originalTitle
        overview = decodableModel.overview
        popularity = decodableModel.popularity
        posterPath = decodableModel.posterPath
        releaseDate = decodableModel.releaseDate
        title = decodableModel.title ?? "-Empty title-"
        video = decodableModel.video
        voteAverage = decodableModel.voteAverage
        voteCount = decodableModel.voteCount
    }
}
