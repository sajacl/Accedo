import Foundation
import AccedoDB
import struct AccedoREST.MoviesAPIResponse
import struct AccedoREST.MovieDecodableModel

protocol MovieRepositoryInterface {
    func getMovies() throws -> [Movie]

    func upsertMovies(_ decodedMovies: [MovieDecodableModel]) throws
}

final class MovieRepository {
    @DatabaseActor
    private let cache: Cache<Int, Movie> = Cache(name: "MovieCache")

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
    }
}

public struct Movie: Hashable {
    public let id: Int
    public let adult: Bool?
    public let backdropPath: String?
    public let genreIDS: [Int]
    public let originalLanguage, originalTitle, overview: String?
    public let popularity: Double?
    public let posterPath, releaseDate, title: String?
    public let video: Bool?
    public let voteAverage: Double?
    public let voteCount: Int?

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
        title = decodableModel.title
        video = decodableModel.video
        voteAverage = decodableModel.voteAverage
        voteCount = decodableModel.voteCount
    }
    }
