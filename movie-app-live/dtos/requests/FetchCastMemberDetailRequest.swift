//
//  FetchCastMemberDetailRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 06. 14..
//

struct FetchCastMemberDetailRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    let castMemberId: Int
    
    func asRequestParams() -> [String: Any]{
        return languageParam
    }
}
