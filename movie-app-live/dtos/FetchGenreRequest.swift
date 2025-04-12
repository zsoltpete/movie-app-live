//
//  Untitled.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 12..
//

struct FetchGenreRequest {
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: String] {
        return [:]
    }
}
