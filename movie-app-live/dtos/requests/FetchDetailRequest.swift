//
//  FetchMovieDetail.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 09..
//

struct FetchDetailRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any] {
        return [:]
    }
}
