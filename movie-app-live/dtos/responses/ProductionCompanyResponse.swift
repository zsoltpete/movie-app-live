//
//  ProductionCompaniesResponse.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 05. 13..
//

struct ProductionCompanyResponse: Decodable {
    let id: Int
    let logoPath: String?
    let name: String
    let originCountry: String

    enum CodingKeys: String, CodingKey {
        case logoPath = "logo_path"
        case originCountry = "origin_country"
        case name
        case id
    }
}
