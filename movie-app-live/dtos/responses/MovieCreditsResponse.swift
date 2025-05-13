//
//  MovieCreditsResponse.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 13..
//

import Foundation

struct MovieCreditsResponse: Codable {
    let id: Int
    let cast: [CastMemberResponse]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
}
