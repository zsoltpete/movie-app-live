//
//  FetchMovieCreditsRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 13..
//

struct FetchMovieCreditsRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return [:]
    }
}
