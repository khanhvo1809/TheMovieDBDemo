//
//  SearchMoviesUseCaseTests.swift
//  TheMovieDBDemoTests
//
//  Created by Khanh Vo on 27/10/2023.
//

import XCTest
@testable import TheMovieDBDemo

final class SearchMoviesUseCaseTests: XCTestCase {
    
    var usecase: SearchMoviesUseCase!

    func testReloadData() throws {
        usecase = SearchMoviesUseCase(
            repository: SearchMoviesRepository()
        )
        usecase.searchKeyword = "Spider Man"
        usecase.reloadData()

        sleep(5)

        let expectedNextPage = 2
        
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
        usecase = SearchMoviesUseCase(
            repository: SearchMoviesRepository()
        )
        usecase.searchKeyword = "Spider Man"
        usecase.loadMore()

        sleep(1)

        XCTAssert(
            usecase.nextPage == 1,
            "Next page should be 1 instead of \(usecase.nextPage)"
        )
    }

    func testLoadMore2() throws {
        let page = 2

        usecase = SearchMoviesUseCase(
            repository: SearchMoviesRepository()
        )
        usecase.searchKeyword = "Spy"
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

    func testSearchNoData() throws {
        let exp = expectation(description: "Perform search has no data")
        
        usecase = SearchMoviesUseCase(
            repository: SearchMoviesRepository(),
            onDataChanged: {
                XCTAssertFalse(
                    self.usecase.hasNextPage,
                    "Should not have next page"
                )
                XCTAssert(
                    self.usecase.nextPage == 1,
                    "Next page should be 1 instead of \(self.usecase.nextPage)"
                )
                exp.fulfill()
            }
        )
        usecase.searchKeyword = "1234567890"
        usecase.searchData()

        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription ?? "error")
        }
    }

    func testSearchHasData() throws {
        let exp = expectation(description: "Perform search has data")
        
        let expectedNextPage = 2
        
        usecase = SearchMoviesUseCase(
            repository: SearchMoviesRepository(),
            onDataChanged: {
                XCTAssertTrue(
                    self.usecase.hasNextPage,
                    "Should have next page"
                )
                XCTAssert(
                    self.usecase.nextPage == expectedNextPage,
                    "Next page should be \(expectedNextPage) instead of \(self.usecase.nextPage)"
                )
                exp.fulfill()
            }
        )
        usecase.searchKeyword = "Spy"

        usecase.searchData()
        
        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription ?? "error")
        }
    }
}
