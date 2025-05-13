//
//  AddFavoriteMovieRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//

struct EditFavoriteBodyRequest: Encodable {
    let movieId: Int
    let isFavorite: Bool
    let mediaType = "movie"
    
    enum CodingKeys: String, CodingKey {
        case isFavorite = "favorite"
        case movieId = "media_id"
        case mediaType = "media_type"
    }
}

struct EditFavoriteRequest: Encodable {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    let movieId: Int
    let isFavorite: Bool
    
    func asRequestParams() -> [String: Any] {
        return [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": isFavorite
        ]
    }
}
