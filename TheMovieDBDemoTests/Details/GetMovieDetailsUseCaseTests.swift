//
//  GetMovieDetailsUseCaseTests.swift
//  TheMovieDBDemoTests
//
//  Created by Khanh Vo on 27/10/2023.
//

import XCTest
@testable import TheMovieDBDemo

final class GetMovieDetailsUseCaseTests: XCTestCase {
    
    var usecase: GetMovieDetailsUseCase!

    func testAbleToGetMovieDetails() throws {
        let exp = expectation(description: "Get Titanic movie")
        
        let movieId = 597
        let expectedTitle = "Titanic"
        
        usecase = GetMovieDetailsUseCase(
            getMovieDetailsRepository: GetMovieDetailsRepository(),
            onDataChanged: {
                XCTAssertNotNil(self.usecase.movie, "Movie should be not nil")
                XCTAssert(self.usecase.movie?.id == movieId, "Movie id should be \(movieId)")
                XCTAssert(self.usecase.movie?.title == expectedTitle, "Movie title should be \(expectedTitle)")
                exp.fulfill()
            }
        )
        usecase.getDetails(movieId: movieId)
        
        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription ?? "error")
        }
    }

    func testNotAbleToGetMovieDetails() throws {
        let exp = expectation(description: "Get Titanic movie")
        
        let movieId = -1
        
        usecase = GetMovieDetailsUseCase(
            getMovieDetailsRepository: GetMovieDetailsRepository(),
            onDataChanged: {
                XCTAssertNil(self.usecase.movie, "Movie should be nil")
                exp.fulfill()
            }
        )
        usecase.getDetails(movieId: movieId)
        
        waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription ?? "error")
        }
    }
}
