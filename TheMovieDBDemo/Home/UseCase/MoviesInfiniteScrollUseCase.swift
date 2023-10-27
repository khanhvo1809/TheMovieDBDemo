//
//  MoviesInfiniteScrollUseCase.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import Foundation

protocol IInfiniteScroll {
    associatedtype T
    
    var isLoading: Bool { get set }
    var nextPage: Int { get set }
    var data: [T] { get set }
    var onDataChanged: (() -> Void)? { get set }
    
    func extraQuery() -> [String: String]
    func reloadData()
    func loadMore()
    func loadData(page: Int)
    func item(at index: Int) -> T?
    func resetData()
}

class MoviesInfiniteScrollUseCase: IInfiniteScroll {
    typealias T = Movie
    
    var repository: IMovieListRepository
    
    init(repository: IMovieListRepository, onDataChanged: (() -> Void)? = nil) {
        self.repository = repository
        self.onDataChanged = onDataChanged
    }

    var isLoading: Bool = false
    var nextPage: Int = 1
    var hasNextPage: Bool = false
    var data: [T] = []
    var onDataChanged: (() -> Void)?
    
    func extraQuery() -> [String : String] {
        return [:]
    }
    
    func reloadData() {
        loadData(page: 1)
    }
    
    func loadMore() {
        if !hasNextPage {
            return
        }
        
        loadData(page: nextPage)
    }
    
    func loadData(page: Int) {
        if isLoading {
            return
        }
        
        isLoading = true
        print("loadData:: \(page)")
        
        let allQuery = ["page": "\(page)"].merging(extraQuery()) { $1 }
        
        repository.all(query: allQuery) { [weak self] result in
            guard let weakSelf = self else { return }
            
            weakSelf.isLoading = false
            
            switch (result) {
            case let .success(res):
                // Update next page
                if res.page < res.totalPages {
                    weakSelf.nextPage = res.page + 1
                    weakSelf.hasNextPage = true
                    print("__DEBUG__ weakSelf.nextPage == \(weakSelf.nextPage)")
                } else {
                    weakSelf.hasNextPage = false
                }
                
                if !res.results.isEmpty {
                    if res.page == 1 {
                        weakSelf.data = res.results
                    } else {
                        weakSelf.data.append(contentsOf: res.results)
                    }
                }
                break
            case let .failure(err):
                print("__DEBUG__ err:: \(err)")
                break
            }
            weakSelf.onDataChanged?()
        }
    }
    
    func item(at index: Int) -> T? {
        if 0 ... data.count ~= index {
            return data[index]
        }
        return nil
    }
    
    func resetData() {
        isLoading = false
        data = []
        nextPage = 1
        hasNextPage = false
        
        onDataChanged?()
    }
}
