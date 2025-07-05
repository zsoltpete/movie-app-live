//
//  AddReviewRequest.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 07. 05..
//

struct AddReviewBodyRequest: Encodable {
    let movieId: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey {
        case rating = "value"
        case movieId = "movie_id"
    }
}

struct AddReviewRequest: Encodable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let rating: Double
    
    func asRequestParams() -> [String: Any] {
        return [
            "movie_id": mediaId,
            "rating": rating
        ]
    }
}
