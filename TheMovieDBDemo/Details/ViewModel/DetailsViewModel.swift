//
//  DetailsViewModel.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

class DetailsViewModel {
    var getMovieDetailsUseCase: GetMovieDetailsUseCase
    
    var input: Input
    var output: Output

    init(input: Input, output: Output) {
        self.input = input
        self.output = output

        self.getMovieDetailsUseCase = GetMovieDetailsUseCase(
            getMovieDetailsRepository: GetMovieDetailsRepository(),
            onDataChanged: output.onDataChanged
        )
        
        self.getMovieDetailsUseCase.getDetails(movieId: self.input.movieId)
    }

    func getMovieDetails() -> Movie? {
        return getMovieDetailsUseCase.movie
    }

    func getError() -> Error? {
        return getMovieDetailsUseCase.error
    }
}

extension DetailsViewModel {
    struct Input {
        var movieId: Int
    }
    
    struct Output {
        var onDataChanged: (() -> Void)?
    }
}
