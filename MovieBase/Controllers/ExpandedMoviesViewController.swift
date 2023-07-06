//
//  ExpandedMoviesViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

import UIKit

class ExpandedViewController: UIViewController, SectionDelegate {
   
    private let movies: [Title] = []
    
    var index: Int = 0
    
    func didSelectSection(_ section: Int) {
        index = section
    }
    
    //MARK: - Data Layer
    public var titles: [Title] = [Title]()
        
    //MARK: - UI
    public lazy var expandCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SectionCollectionViewCell.self, forCellWithReuseIdentifier: SectionCollectionViewCell.nameOfClass)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(expandCollectionView)
        makeConstraints()
        addBackButton()
        
        func didSelectSection(_ section: Int) {
            print(section)
            print("received section")
            index = section
        }
        
        fetchMovies(flag: "getPopularMovies")
    }
    
//    private func fetchMovies() {
//        APICaller.shared.getNowPlayingMovies { [weak self] result in
//            switch result {
//            case .success(let titles):
//                self?.titles = titles
//                DispatchQueue.main.async {
//                    self?.expandCollectionView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
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


    // MARK: - Constraints
    private func makeConstraints() {
        expandCollectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    private func addBackButton() {
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        backButton.tintColor = .red
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ExpandedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(titles.count)
        print("expanded")
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCollectionViewCell.nameOfClass, for: indexPath) as? SectionCollectionViewCell else {
            return UICollectionViewCell()  }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        cell.averageLabel.text = String(describing: titles[indexPath.row].vote_average)
        
        return cell
    }
}
