//
//  FetchFavoriteMovieRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//

struct FetchFavoriteMovieRequest {
    let accessToken: String = Config.bearerToken
    let accountId: Int = 21889570
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
