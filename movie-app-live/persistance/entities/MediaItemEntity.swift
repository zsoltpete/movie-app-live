//
//  MediaItemEntity.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 15..
//

import RealmSwift
import Foundation

class MediaItemEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var year: String
    @Persisted var duration: String
    @Persisted var imageUrlString: String?
    @Persisted var rating: Double
    @Persisted var voteCount: Int
}

extension MediaItemEntity {
    var toDomain: MediaItem {
        MediaItem(
            id: id,
            title: title,
            year: year,
            duration: duration,
            imageUrl: imageUrlString.flatMap(URL.init(string:)),
            rating: rating,
            voteCount: voteCount
        )
    }

   convenience init(from domains: MediaItem) {
        self.init()
        self.id = domains.id
        self.title = domains.title
        self.year = domains.year
        self.duration = domains.duration
        self.imageUrlString = domains.imageUrl?.absoluteString
        self.rating = domains.rating
        self.voteCount = domains.voteCount
    }
}

