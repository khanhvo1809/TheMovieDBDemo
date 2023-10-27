//
//  MovieItemCell.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import UIKit

protocol IMovieItemCell {
    var image: String? { get set }
    var title: String { get set }
    var description: String { get set }
    var vote: Double? { get set }
    var date: String { get set }
}

struct MovieData: IMovieItemCell {
    var image: String?
    var title: String
    var description: String
    var vote: Double?
    var date: String
}

class MovieItemCell: UITableViewCell {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieDescription: UILabel!
    @IBOutlet weak var movieVote: UILabel!
    @IBOutlet weak var movieDate: UILabel!
    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .default, reuseIdentifier: MovieItemCell.cellIdentifier)
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    static let cellIdentifier = "MovieItemCell"
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func setupViews() {
        movieImage.backgroundColor = .lightGray
        movieImage.clipsToBounds = true
        movieImage.layer.masksToBounds = true
        movieImage.layer.cornerRadius = 16
    }
    
    func configure(_ data: IMovieItemCell?) {
        setupViews()
        
        movieImage.image = nil
        movieTitle.text = data?.title ?? ""
        movieDescription.text = data?.description ?? ""
        movieVote.text = String(format: "%.1f", data?.vote ?? 0.0)
        movieDate.text = data?.date ?? ""
        
        SimpleImageCache.shared.loadImage(data?.image) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let weakSelf = self else { return }
                
                weakSelf.movieImage.image = image
            }
        }
    }
}
