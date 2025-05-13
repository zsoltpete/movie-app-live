//
//  EditFavoriteResponse.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 06..
//

struct EditFavoriteResponse : Decodable {
    let success : Bool
    let statusCode : Int
    let statusMessage : String

    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}
