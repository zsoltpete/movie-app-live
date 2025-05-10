//
//  SpokenLanguageResponse.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 10..
//

struct SpokenLanguageResponse: Decodable {
    let englishName: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case name
    }
}
