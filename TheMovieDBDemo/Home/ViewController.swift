//
//  ViewController.swift
//  TheMovieDBDemo
//
//  Created by Khanh Vo on 27/10/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var networkNotice: UIView!
    @IBOutlet weak var networkNoticeLabel: UILabel!
    @IBOutlet weak var networkNoticeHeight: NSLayoutConstraint!

    let REMAIN_ROWS_THRESHOLD = 10
    
    var viewModel: ViewModel!
    
    @objc func onNetworkChanged() {
        let connectionStatus = SimpleNetworkDetection.shared.connectionStatus
        
        if (connectionStatus) {
            DispatchQueue.main.async {
                self.networkNotice.backgroundColor = .green
                self.networkNoticeLabel.textColor = .black
                self.networkNoticeLabel.text = "You're online"
            }
        } else {
            DispatchQueue.main.async {
                self.networkNotice.backgroundColor = .red
                self.networkNoticeLabel.textColor = .white
                self.networkNoticeLabel.text = "You're offline"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Observe network connection
        onNetworkChanged()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNetworkChanged),
            name: Notification.Name(rawValue: "networkChanged"),
            object: nil
        )
                
        // Setup UI
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(MovieItemCell.nib, forCellReuseIdentifier: MovieItemCell.cellIdentifier)
        
        // Setup ViewModel
        let viewModel = ViewModel(
            input: ViewModel.Input(),
            output: ViewModel.Output(
                onDataChanged: {
                    DispatchQueue.main.async { [weak self] in
                        guard let weakSelf = self else { return }
                        
                        if let error = weakSelf.viewModel.getError() {
                            weakSelf.showError(error)
                            return
                        }
                        
                        weakSelf.tableView.reloadData()
                    }
                }
            )
        )
        viewModel.loadData(page: 1)
        self.viewModel = viewModel
    }

    func showError(_ error: Error?) {
        let alertVC = UIAlertController(
            title: "Error",
            message: error?.localizedDescription ?? "Please check network connection.",
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieItemCell.cellIdentifier, for: indexPath) as? MovieItemCell else {
            return UITableViewCell(style: .default, reuseIdentifier: MovieItemCell.cellIdentifier)
        }
        
        let item = viewModel.item(at: indexPath.row)
        
        cell.configure(
            MovieData(
                image: Constants.IMAGE_BASE_URL + "/w92" + (item?.posterPath ?? ""),
                title: item?.title ?? "",
                description: item?.overview ?? "",
                vote: item?.voteAverage,
                date: item?.releaseDate ?? "Unknown"
            )
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.total()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= viewModel.total() - REMAIN_ROWS_THRESHOLD {
            viewModel.loadMore()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (searchBar.isFirstResponder) {
            searchBar.resignFirstResponder()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (searchBar.isFirstResponder) {
            searchBar.resignFirstResponder()
        }

        let item = viewModel.item(at: indexPath.row)
        
        guard
            let movieId = item?.id,
                let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsNavigationController") as? UINavigationController
        else { return }
        
        
        let vc = nav.viewControllers.first as? DetailsViewController
        vc?.movieId = movieId
        self.present(nav, animated: true)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchData(text: searchText)
    }
}
