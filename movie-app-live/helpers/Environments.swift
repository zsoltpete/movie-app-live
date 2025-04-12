//
//  Environment.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 11..
//


struct Environment {
    enum Name {
        case prod
        case dev
    }
#if ENV_PROD
    static let name: Name = .prod
#else
    static let name: Name = .dev
#endif
}
