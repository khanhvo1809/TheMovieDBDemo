//
//  SearchMoviesUseCase.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

class SearchMoviesUseCase: MoviesInfiniteScrollUseCase {
    let MIN_SEARCH_KEYWORD_LENGTH = 3
    var searchTask: DispatchWorkItem?
    
    var searchKeyword: String? {
        didSet {
            if let length = searchKeyword?.count, length >= MIN_SEARCH_KEYWORD_LENGTH {
                searchData()
            } else {
                resetData()
            }
        }
    }
    
    func searchData() {
        // Debounce search data 300ms
        self.searchTask?.cancel()
        
        let task = DispatchWorkItem {
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                
                weakSelf.loadData(page: 1)
            }
        }
        
        self.searchTask = task

        DispatchQueue.main.asyncAfter(
            deadline: .now() + .milliseconds(300),
            execute: task
        )
    }
    
    override func extraQuery() -> [String : String] {
        return [
            "include_adult": "false",
            "query": searchKeyword ?? ""
        ]
    }
}
