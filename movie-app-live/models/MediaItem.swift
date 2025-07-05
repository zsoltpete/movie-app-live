//
//  MediaItem.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import Foundation

struct MediaItemPage {
    let page: Int
    let totalPages: Int
    let mediaItems: [MediaItem]
    
    init(dto: MoviePageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
    
    init(dto: TVPageResponse) {
        self.page = dto.page
        self.totalPages = dto.totalPages
        self.mediaItems = dto.results.map(MediaItem.init(dto:))
    }
}

enum MediaItemType: Decodable {
    case tv
    case movie
    case unknown
}

struct MediaItem: Identifiable {
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let type: MediaItemType
    
    init(id: Int) {
        self.id = id
        self.title = "-1"
        self.year = "-1"
        self.duration = "-1"
        self.imageUrl = nil
        self.rating = -1
        self.voteCount = -1
        self.type = .unknown
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.type = .unknown
    }
    
    init(dto: MovieResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "mediaItem.default.duration".localized()
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.type = .movie
        
    }
    
    init(dto: TVResponse) {
        let releaseDate: String? = dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = ""
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.type = .tv
        
    }
    
    init(detail: MediaItemDetail) {
        self.id = detail.id
        self.title = detail.title
        self.year = detail.year
        self.duration = "mediaItem.default.duration".localized()
        self.imageUrl = detail.imageUrl
        self.rating = detail.rating
        self.voteCount = detail.voteCount
        self.type = detail.type
        
    }
    
}
