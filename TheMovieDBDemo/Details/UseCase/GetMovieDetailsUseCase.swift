//
//  GetMovieDetailsUseCase.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

class GetMovieDetailsUseCase {
    private var getMovieDetailsRepository: GetMovieDetailsRepository
    private var onDataChanged: (() -> Void)? = nil

    var movie: Movie?
    var error: Error?
    
    var isLoading = false
    
    init(
        getMovieDetailsRepository: GetMovieDetailsRepository,
        onDataChanged: (() -> Void)? = nil
    ) {
        self.getMovieDetailsRepository = getMovieDetailsRepository
        self.onDataChanged = onDataChanged
    }

    func getDetails(movieId: Int) {
        print("__DEBUG__ movieId:: \(movieId)")
        getMovieDetailsRepository.get(id: movieId) { [weak self] result in
            guard let weakSelf = self else { return }
            
            weakSelf.isLoading = false
            weakSelf.error = nil
            
            switch (result) {
            case let .success(movie):
                weakSelf.movie = movie
                break
            case let .failure(err):
                weakSelf.movie = nil
                weakSelf.error = err
                print("__DEBUG__ err:: \(err)")
                break
            }
            weakSelf.onDataChanged?()
        }
    }
}
