//
//  GetTrendingMoviesUseCaseTests.swift
//  TheMovieDBDemoTests
//
//  Created by Khanh Vo on 27/10/2023.
//

import XCTest
@testable import TheMovieDBDemo

final class GetTrendingMoviesUseCaseTests: XCTestCase {
    
    var usecase: GetTrendingMoviesUseCase!

    override func setUpWithError() throws {
        usecase = GetTrendingMoviesUseCase(
            repository: GetTrendingMoviesRepository(),
            onDataChanged: {
                print("__TEST__ onDataChanged")
            }
        )
    }

    func testReloadData() throws {
        let expectedNextPage = 2
        usecase.reloadData()
        
        sleep(5)
        
        XCTAssert(
            usecase.hasNextPage,
            "Should has next page"
        )
        XCTAssert(
            usecase.nextPage == expectedNextPage,
            "Next page should be \(expectedNextPage) instead of \(usecase.nextPage)"
        )
    }

    func testLoadMore() throws {
        usecase.loadMore()
        
        sleep(1)
        
        XCTAssert(
            usecase.nextPage == 1,
            "Next page should be 1 instead of \(usecase.nextPage)"
        )
    }

    func testLoadMore2() throws {
        let page = 2

        usecase.loadData(page: page)
        
        sleep(5)
        
        let expectedNextPage = usecase.nextPage + 1
        
        usecase.loadMore()
        
        sleep(5)
        
        XCTAssert(
            usecase.nextPage == expectedNextPage,
            "Next page should be \(expectedNextPage) instead of \(usecase.nextPage)"
        )
    }

    func testLoadDataPage() throws {
        let page = 2

        usecase.loadData(page: page)
//        usecase.loadData(page: page + 1)

        sleep(5)
        
        let expectedNextPage = page + 1
        
        XCTAssert(
            usecase.nextPage == expectedNextPage,
            "Next page should be \(expectedNextPage) instead of \(usecase.nextPage)"
        )
    }

    func testNotAbleToLoadDataPage() throws {
        usecase.isLoading = true
        usecase.loadData(page: 1)
        
        XCTAssertFalse(usecase.hasNextPage, "Should not has next page")
    }
}
