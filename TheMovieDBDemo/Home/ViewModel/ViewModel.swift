//
//  ViewModel.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

class ViewModel {
    typealias T = Movie
    
    var getTrendingMoviesUseCase: GetTrendingMoviesUseCase
    var searchMoviesUseCase: SearchMoviesUseCase
    
    var input: Input
    var output: Output

    var mode = Mode.trending {
        didSet {
            if oldValue != mode {
                self.output.onDataChanged?()
                print("__DEBUG__ mode changed to:: \(mode)")
            }
        }
    }

    init(input: Input, output: Output) {
        self.input = input
        self.output = output

        self.getTrendingMoviesUseCase = GetTrendingMoviesUseCase(
            repository: GetTrendingMoviesRepository(),
            onDataChanged: output.onDataChanged
        )
        self.searchMoviesUseCase = SearchMoviesUseCase(
            repository: SearchMoviesRepository(),
            onDataChanged: output.onDataChanged
        )
    }
    
    func searchData(text: String) {
        // Update search keyword
        self.searchMoviesUseCase.searchKeyword = text
        
        // Update mode if needed
        mode = text.count != 0 ? .search : .trending
    }

    func getError() -> Error? {
        return mode == .search
            ? self.searchMoviesUseCase.error
            : self.getTrendingMoviesUseCase.error
    }
    
    func loadMore() {
        if mode == .search {
            self.searchMoviesUseCase.loadMore()
        } else {
            self.getTrendingMoviesUseCase.loadMore()
        }
    }
    
    func loadData(page: Int) {
        if mode == .search {
            self.searchMoviesUseCase.loadData(page: page)
        } else {
            self.getTrendingMoviesUseCase.loadData(page: page)
        }
    }
    
    func item(at index: Int) -> T? {
        return mode == .search
            ? self.searchMoviesUseCase.item(at: index)
            : self.getTrendingMoviesUseCase.item(at: index)
    }
    
    func total() -> Int {
        return mode == .search
            ? self.searchMoviesUseCase.data.count
            : self.getTrendingMoviesUseCase.data.count
    }
}

extension ViewModel {
    struct Input { }
    
    struct Output {
        var onDataChanged: (() -> Void)?
    }
    
    enum Mode {
        case trending
        case search
    }
}
