//
//  EditFavoriteResult.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 13..
//

struct EditFavoriteResult {
    let success: Bool
    let statusCode: Int
    let statusMessage: String
    
    init(dto: EditFavoriteResponse) {
        self.success = dto.success
        self.statusCode = dto.statusCode
        self.statusMessage = dto.statusMessage
    }
}
