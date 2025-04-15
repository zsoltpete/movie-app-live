//
//  MoviesApi.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
}

extension MoviesApi: TargetType {
    var baseURL: URL {
        // TODO: Másik baseurl
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url not valid url")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchMovies:
            return "search/movie"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchMovies:
            return .get
        }
    }
    
    // TODO: Másik encoding
    var task: Task {
        switch self {
        case .fetchGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        }
    }
    
}
