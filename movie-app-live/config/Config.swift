//
//  Config.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 12..
//

import Foundation

enum Config {
    private static func value<T>(forKey key: String, as type: T.Type) -> T {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let value = dict[key] as? T else {
            fatalError("Config.plist file or key '\(key)' not found or not of type \(T.self)")
        }
        return value
    }

    static var apiToken: String {
        value(forKey: "API_TOKEN", as: String.self)
    }

    static var accountId: Int {
        return value(forKey: "ACCOUNT_ID", as: Int.self)
    }

    static var bearerToken: String {
        "Bearer \(apiToken)"
    }
}


