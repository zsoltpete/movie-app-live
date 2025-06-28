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
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMediaListRequest)
    case fetchTV(req: FetchMediaListRequest)
    case searchMovies(req: SearchMediaItemRequest)
    case searchTVs(req: SearchMediaItemRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMovieRequest)
    case editFavoriteMovie(req: EditFavoriteRequest)
    case fetchMovieDetail(req: FetchDetailRequest)
    case fetchTVDetail(req: FetchDetailRequest)
    case fetchMovieCredits(req: FetchMovieCreditsRequest)
    case fetchTVCredits(req: FetchMovieCreditsRequest)
    case fetchMovieReviews(req: FetchMovieReviewsRequest)
    case fetchCastMemberDetail(req: FetchCastMemberDetailRequest)
    case fetchCompanyDetail(req: FetchCastMemberDetailRequest)
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
        case .fetchTVGenres:
            return "genre/tv/list"
        case .fetchMovies:
            return "discover/movie"
        case .searchMovies:
            return "search/movie"
        case .searchTVs:
            return "search/tv"
        case let .fetchFavoriteMovies(req):
            return "account/\(req.accountId)/favorite/movies"
        case .editFavoriteMovie(req: let req):
            return "account/\(req.accountId)/favorite"
        case .fetchTV:
            return "discover/tv"
        case .fetchMovieDetail(req: let req):
            return "movie/\(req.mediaId)"
        case .fetchTVDetail(req: let req):
            return "tv/\(req.mediaId)"
        case .fetchMovieCredits(req: let req):
            return "movie/\(req.mediaId)/credits"
        case .fetchTVCredits(req: let req):
            return "tv/\(req.mediaId)/credits"
        case .fetchMovieReviews(req: let req):
            return "movie/\(req.mediaId)/reviews"
        case .fetchCastMemberDetail(req: let req):
            return "person/\(req.castMemberId)"
        case .fetchCompanyDetail(req: let req):
            return "company/\(req.castMemberId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies, .searchTVs, .fetchFavoriteMovies, .fetchMovieDetail, .fetchMovieCredits, .fetchMovieReviews, .fetchCastMemberDetail, .fetchCompanyDetail, .fetchTVDetail, .fetchTVCredits:
            return .get
        case .editFavoriteMovie:
            return .post
        }
    }
    
    // TODO: Másik encoding
    var task: Task {
        switch self {
        case .fetchGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVGenres(let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchTV(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .searchTVs(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavoriteMovies(req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .editFavoriteMovie(req: let req):
            //return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.httpBody)
            let request = EditFavoriteBodyRequest(movieId: req.movieId, isFavorite: req.isFavorite)
                return .requestJSONEncodable(request)
        case .fetchMovieDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVDetail(req: let req):
                return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchTVCredits(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieReviews(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCastMemberDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        case .fetchCompanyDetail(req: let req):
            return .requestParameters(parameters: req.asRequestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization": req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization": req.accessToken]
        case let .fetchTV(req):
            return ["Authorization": req.accessToken]
        case let .searchMovies(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case let .searchTVs(req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case let .fetchFavoriteMovies(req):
            return ["Authorization": req.accessToken]
        case .editFavoriteMovie(req: let req):
            return [
                "Authorization": req.accessToken,
                "accept": "application/json"
            ]
        case .fetchMovieDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchTVDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchMovieCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchTVCredits(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchMovieReviews(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCastMemberDetail(req: let req):
            return ["Authorization": req.accessToken]
        case .fetchCompanyDetail(req: let req):
            return ["Authorization": req.accessToken]
        }
    }
    
}
