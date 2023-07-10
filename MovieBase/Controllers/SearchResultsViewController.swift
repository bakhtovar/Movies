//
//  SearchResultsViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 09/07/23.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    //MARK: - Data Layer
    public var titles: [Title] = [Title]()
    
    //MARK: - UI
    public lazy var searchResultsCollectionView: UICollectionView  = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ExpandCollectionViewCell.self, forCellWithReuseIdentifier: ExpandCollectionViewCell.nameOfClass)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultsCollectionView)
        makeConstraints()
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        searchResultsCollectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
}

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandCollectionViewCell.nameOfClass, for: indexPath) as? ExpandCollectionViewCell else {
            return UICollectionViewCell()  }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        let selectedMovie = titles[indexPath.row]
        detailViewController.configureTitle(with: selectedMovie)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
