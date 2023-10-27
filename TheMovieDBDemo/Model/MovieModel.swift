//
//  MovieModel.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

protocol IMovie: Codable {
    var id: Int { get set }
    var title: String { get set }
    var overview: String { get set }
    var releaseDate: String? { get set }
    var voteAverage: Double? { get set }
    var backdropPath: String? { get set }
    var posterPath: String? { get set }
}

struct Movie: IMovie {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
    
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String?
    var voteAverage: Double?
    var backdropPath: String?
    var posterPath: String?
}

protocol IPagingResponse: Codable {
    associatedtype T: Codable
    
    var page: Int { get set }
    var results: [T] { get set }
    var totalPages: Int { get set }
    var totalResults: Int { get set }
}

struct MovieResponse<T: IMovie>: IPagingResponse {
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    var page: Int
    var results: [T]
    var totalPages: Int
    var totalResults: Int
}
