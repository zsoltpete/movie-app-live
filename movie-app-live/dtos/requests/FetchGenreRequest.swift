//
//  Untitled.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 12..
//

import Foundation

struct FetchGenreRequest: LocalizedRequestable {
    let accessToken: String = Config.bearerToken
    
    func asRequestParams() -> [String: Any] {
        return languageParam
    }
}

protocol LocalizedRequestable {
    var languageParam: [String: Any] { get }
}

extension LocalizedRequestable {
    var languageParam: [String: Any] {
        ["language": Bundle.getLangCode()]
    }
}

func + (lhs: [String: Any], rhs: [String: Any]) -> [String: Any] {
    var result = lhs
    rhs.forEach { result[$0.key] = $0.value }
    return result
}
