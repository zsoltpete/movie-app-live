//
//  FetchMovieReviewsRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 20..
//

import Foundation

struct FetchMovieReviewsRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return [:]
    }
} 