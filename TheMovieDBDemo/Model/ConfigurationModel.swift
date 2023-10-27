//
//  ConfigurationModel.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

struct ConfigurationImages: Codable {
    enum CodingKeys: String, CodingKey {
        case baseUrl = "base_url"
        case secureBaseUrl = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case posterSizes = "poster_sizes"
    }
    
    var baseUrl: String
    var secureBaseUrl: String
    var backdropSizes: [String]
    var posterSizes: [String]
}

struct Configuration: Codable {
    var images: ConfigurationImages
}
