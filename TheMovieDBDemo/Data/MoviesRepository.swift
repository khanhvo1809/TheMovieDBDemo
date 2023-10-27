//
//  TrendingRepository.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

protocol IMovieListRepository {
    func all(
        query: [String: String],
        completion: @escaping (Result<MovieResponse<Movie>, Error>) -> Void
    )
}

protocol IMovieDetailsRepository {
    func get(
        id: Int,
        query: [String: String],
        completion: @escaping (Result<Movie, Error>) -> Void
    )
}

struct GetTrendingMoviesRepository: IMovieListRepository {
    func all(query: [String: String] = [:], completion: @escaping (Result<MovieResponse<Movie>, Error>) -> Void) {
        SimpleNetwork.get(
            "https://api.themoviedb.org/3/trending/movie/day",
            queryParams: query,
            completion: completion
        )
    }
}

struct SearchMoviesRepository: IMovieListRepository {
    func all(query: [String: String] = [:], completion: @escaping (Result<MovieResponse<Movie>, Error>) -> Void) {
        SimpleNetwork.get(
            "https://api.themoviedb.org/3/search/movie",
            queryParams: query,
            cacheResponse: true,
            completion: completion
        )
    }
}

struct GetMovieDetailsRepository: IMovieDetailsRepository {
    func get(
        id: Int,
        query: [String: String] = [:],
        completion: @escaping (Result<Movie, Error>) -> Void
    ) {
        SimpleNetwork.get(
            "https://api.themoviedb.org/3/movie/\(id)",
            queryParams: query,
            completion: completion
        )
    }
}
