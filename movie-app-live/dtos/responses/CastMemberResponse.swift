//
//  CastMemberResponse.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 13..
//
struct CastMemberResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profilePath = "profile_path"
    }
}
