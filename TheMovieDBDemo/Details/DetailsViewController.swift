//
//  DetailsViewController.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieVote: UILabel!
    @IBOutlet weak var movieDate: UILabel!

    @IBAction func dismissHandler() {
        dismiss(animated: true)
    }
    
    var viewModel: DetailsViewModel!
    var movieId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup View
        navigationItem.title = "Movie"

        // Setup ViewModel
        let viewModel = DetailsViewModel(
            input: DetailsViewModel.Input(
                movieId: movieId
            ),
            output: DetailsViewModel.Output(
                onDataChanged: {
                    DispatchQueue.main.async { [weak self] in
                        guard let weakSelf = self else { return }
                        
                        weakSelf.reloadData()
                    }
                }
            )
        )
        self.viewModel = viewModel
    }
    
    func reloadData() {
        let movie = viewModel.getMovieDetails()
        
        guard let movie = movie else {
            showDetailsError()
            return
        }

        movieImage.image = nil
        movieTitle.text = movie.title
        movieDescription.text = movie.overview
        movieVote.text = String(format: "%.1f", movie.voteAverage ?? 0.0)
        movieDate.text = movie.releaseDate ?? ""
        
        let imageUrlString = Constants.IMAGE_BASE_URL + "/w500" + (movie.backdropPath ?? "")
        SimpleImageCache.shared.loadImage(imageUrlString) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                
                weakSelf.movieImage.image = image
            }
        }
    }

    func showDetailsError() {
        let alertVC = UIAlertController(
            title: "Error",
            message: "Cannot get movie details. Please check network connection.",
            preferredStyle: .alert
        )
        
        alertVC.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                self.dismiss(animated: true)
            }
        )
        
        present(alertVC, animated: true)
    }
}
