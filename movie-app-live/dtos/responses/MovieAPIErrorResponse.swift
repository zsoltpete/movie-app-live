//
//  MovieAPIErrorResponse.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 15..
//

struct MovieAPIErrorResponse: Decodable {
    let statusCode: Int
    let statusMessage: String
    let success: Bool
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
        case success = "success"
    }
}
