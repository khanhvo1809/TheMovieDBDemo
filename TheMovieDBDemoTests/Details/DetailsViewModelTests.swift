//
//  DetailsViewModelTests.swift
//  TheMovieDBDemoTests
//
//  Created by Khanh Vo on 27/10/2023.
//

import XCTest
@testable import TheMovieDBDemo

final class DetailsViewModelTests: XCTestCase {
    func testAbleToGetDetails() throws {
        let movieId = 597
        let expectedTitle = "Titanic"

        let viewModel = DetailsViewModel(
            input: DetailsViewModel.Input(movieId: movieId),
            output: DetailsViewModel.Output()
        )
        
        sleep(5)
        
        let movie = viewModel.getMovieDetails()
        XCTAssertNotNil(movie, "Movie should be not nil")
        XCTAssert(movie?.id == movieId, "Movie id should be \(movieId)")
        XCTAssert(movie?.title == expectedTitle, "Movie title should be \(expectedTitle)")
    }

    func testNotAbleToGetDetails() throws {
        let movieId = -1

        let viewModel = DetailsViewModel(
            input: DetailsViewModel.Input(movieId: movieId),
            output: DetailsViewModel.Output()
        )
        
        sleep(5)

        let movie = viewModel.getMovieDetails()
        XCTAssertNil(movie, "Movie data should be nil")
    }
}
