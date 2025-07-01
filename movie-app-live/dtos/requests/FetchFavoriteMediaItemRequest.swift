//
//  FetchFavoriteMediaItemRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//

struct FetchFavoriteMediaItemRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let accountId: Int = Config.accountId
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}
