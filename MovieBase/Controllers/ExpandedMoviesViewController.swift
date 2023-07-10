//
//  ExpandedMoviesViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class ExpandedViewController: UIViewController {
    
    // MARK: - Data Layer
    public var titles: [Title] = []
    private let movies: [Title] = []
    let sectionsTitle: [String] = ["getPopularMovies", "getNowPlayingMovies", "getUpcomingMovies"]
    let titleName: [String] = ["Popular", "Now Playing ", "Upcoming"]
    
    var index: Int = 0
    
    // MARK: - UI
    public lazy var expandCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SectionCollectionViewCell.self, forCellWithReuseIdentifier: SectionCollectionViewCell.nameOfClass)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(expandCollectionView)
        addBackButton()
        makeConstraints()
        
        if index >= 0 && index < sectionsTitle.count {
            let flag = sectionsTitle[index].trimmingCharacters(in: .whitespaces)
            fetchMovies(flag: flag)
            title = titleName[index]
        }
        
        expandCollectionView.addSubview(refreshControl)
    }
    
    // MARK: - Private Methods
    
    private func fetchMovies(flag: String) {
        switch flag {
        case "getPopularMovies":
            APICaller.shared.getPopularMovies { [weak self] result in
                self?.handleAPICallResult(result, for: self)
            }
        case "getNowPlayingMovies":
            APICaller.shared.getNowPlayingMovies { [weak self] result in
                self?.handleAPICallResult(result, for: self)
            }
        case "getUpcomingMovies":
            APICaller.shared.getUpcomingMovies { [weak self] result in
                self?.handleAPICallResult(result, for: self)
            }
        default:
            print("Invalid flag")
        }
    }
    
    private func handleAPICallResult(_ result: Result<[Title], Error>, for controller: ExpandedViewController?) {
        switch result {
        case .success(let titles):
            controller?.titles = titles
            DispatchQueue.main.async {
                controller?.expandCollectionView.reloadData()
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func makeConstraints() {
        expandCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .yellow
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    @objc private func backButtonTapped() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshData() {
        DispatchQueue.main.async {
            let flag = self.sectionsTitle[self.index].trimmingCharacters(in: .whitespaces)
            self.fetchMovies(flag: flag)
            self.expandCollectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

extension ExpandedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCollectionViewCell.nameOfClass, for: indexPath) as? SectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        cell.averageLabel.text = String(describing: titles[indexPath.row].vote_average)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            let detailViewController = DetailViewController()
            let selectedMovie = self?.titles[indexPath.row]
            
            if let movie = selectedMovie {
                detailViewController.configureTitle(with: movie)
            }
            
            self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
