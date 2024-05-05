import Foundation

// MARK: - Genres
public struct GenresDecodableModel: Codable {
    public let genres: [GenreDecodableModel]?
}

// MARK: - Genre
public struct GenreDecodableModel: Codable {
    public let id: Int?
    public let name: String?
}
