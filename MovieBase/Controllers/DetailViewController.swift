//
//  DetailViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//


import UIKit
import SnapKit
import SDWebImage

protocol DetailConfigurable {
    var original_title: String { get }
    var overview: String { get }
    var release_date: String? { get }
    var vote_average: Double { get }
    var poster_path: String? { get }
}

class DetailViewController: UIViewController {
    
    // MARK: - UI
    
    var status = 0
    var moviesCell = MoviesTableViewCell()
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        return view
    }()
    
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "WebView") // Replace with your own image name
        return imageView
    }()
    
    private lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WebView") // Replace with your own image name
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Movie Title"
        return label
    }()
    
    private lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.numberOfLines = 0
        label.text = "Movie description goes here" // Replace with the actual movie description
        return label
    }()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 7
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var backButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .yellow
        return button
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupConstraints()
        configureNavigationBar()
        
            DispatchQueue.main.async {
                self.backgroundImageView.image = UIImage(named: "WebView")
            }
        
        moviesCell.didSelectItem = { [weak self] title, indexPath in
                   guard let self = self else { return }
                   self.moviesCell.downloadTitleAt(indexPath: indexPath)
               }
        
//        showLoadingIndicator()
        
        navigationController?.navigationBar.isTranslucent = false
    
    }
//    
//    override func viewWillLayoutSubviews() {
//        let loader = self.loader()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.stopLoader(loader: loader)
//        }
//    }

    // MARK: - Private Methods
    @objc private func downloadButtonTapped(sender: UIButton) {
        // Perform the necessary action for downloading the title
        guard let collectionView = sender.superview?.superview as? UICollectionView,
              let indexPath = collectionView.indexPath(for: sender.superview as! UICollectionViewCell) else {
            return
        }
        moviesCell.downloadTitleAt(indexPath: indexPath)
        
        print("works")
        print(moviesCell.downloadTitleAt(indexPath: indexPath))
    }
    
    private func addSubviews() {
        view.addSubview(loadingIndicator)
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(shadowView)
        view.addSubview(movieImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(downloadButton)
        
    }
    
    private func setupConstraints() {
        loadingIndicator.snp.makeConstraints { make in
                   make.center.equalToSuperview()
               }
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            if status == 0 {
                make.top.equalToSuperview().inset(-50)
            } else if status == 1 {
                make.top.equalToSuperview().inset(-100)
            }
            make.height.equalTo(300)
        }
        
        shadowView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(150)
            make.width.equalTo(100)
            make.height.equalTo(170)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(20)
            make.leading.equalTo(movieImageView.snp.trailing).offset(20)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(20)
            make.leading.equalTo(movieImageView)
            make.trailing.equalToSuperview().inset(20)
        }
        
        downloadButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(25)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
    }
    
    private func configureNavigationBar() {
       //navigationController?.navigationBar.barTintColor = .yellow
        navigationController?.navigationBar.tintColor = .yellow
     //   navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.yellow]
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.setNavigationBarHidden(false, animated: false)
       // navigationController?.interactivePopGestureRecognizer?.delegate = self
        //navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
        func showLoadingIndicator() {
           loadingIndicator.startAnimating()
       }

        func hideLoadingIndicator() {
           loadingIndicator.stopAnimating()
       }

       
    // MARK: - Public Methods
    
    public func configureMovie(with model: MovieItem) {
       // moviesCell.downloadTitleAt(indexPath: model[indexPath.row])
        titleLabel.text = model.original_title
        descriptionLabel.text = model.overview
        
        showLoadingIndicator()
        
        let formattedDate = formatDate(model.release_date)
        let rating = String(format: "%.1f", model.vote_average)
        let combinedText = "\(formattedDate) - \(rating) ⭐️"
        let attributedText = NSAttributedString(string: combinedText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)
        ])
        releaseDateLabel.attributedText = attributedText
        
        if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w1280/\(posterPath)") {
            backgroundImageView.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
            movieImageView.sd_setImage(with: url, completed: nil)
        }
        
        hideLoadingIndicator()
    }
    
    public func configureTitle(with model: Title) {
    
        titleLabel.text = model.original_title
        descriptionLabel.text = model.overview
        
        let formattedDate = formatDate(model.release_date)
        let rating = String(format: "%.1f", model.vote_average)
        let combinedText = "\(formattedDate) - \(rating) ⭐️"
        let attributedText = NSAttributedString(string: combinedText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)
        ])
        releaseDateLabel.attributedText = attributedText
        
        if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w1280/\(posterPath)") {
            backgroundImageView.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
            movieImageView.sd_setImage(with: url, completed: nil)
        }
        
        hideLoadingIndicator()
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else {
            return "Unknown"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: date)
        }
        
        return "Unknown"
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
