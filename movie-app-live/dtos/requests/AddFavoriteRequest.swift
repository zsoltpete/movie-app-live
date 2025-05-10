//
//  AddFavoriteMovieRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//

struct AddFavoriteRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    let movieId: Int
    
    func asRequestParams() -> [String: Any] {
        return [
            "media_type": "movie",
            "media_id": movieId,
            "favorite": true
        ]
    }
}
