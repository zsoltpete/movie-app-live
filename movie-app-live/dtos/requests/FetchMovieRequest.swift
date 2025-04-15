//
//  FetchMoviewRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

struct FetchMoviesRequest {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    
    func asRequestParams() -> [String: Any] {
        return ["with_genres": genreId]
    }
}
