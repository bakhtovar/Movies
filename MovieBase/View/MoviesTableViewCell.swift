////
////  MoviesTableViewCell.swift
////  MovieBase
////
////  Created by Bakhtovar on 05/07/23.
////
//
//import UIKit
//
//
//class MoviesTableViewCell: UITableViewCell {
//
//    weak var navigationController: UINavigationController?
//    private var titles: [Title] = [Title]()
//
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 120, height: 170)
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(SectionCollectionViewCell.self, forCellWithReuseIdentifier: SectionCollectionViewCell.nameOfClass)
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        return collectionView
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .systemBackground
//        addSubviews()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public func configure(with titles:[Title]) {
//        self.titles = titles
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {[weak self] in
//            self?.collectionView.reloadData()
//        }
//    }
//
//    // MARK: - Private
//    private func addSubviews() {
//        contentView.addSubview(collectionView)
//    }
//
//    // MARK: - Constraints
//    override func updateConstraints() {
//        collectionView.snp.updateConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        super.updateConstraints()
//    }
//
//}
//
//extension MoviesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCollectionViewCell.nameOfClass, for: indexPath) as? SectionCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//
//        guard let model = titles[indexPath.row].poster_path else {
//            return UICollectionViewCell()
//        }
//        cell.configure(with: model)
//        cell.averageLabel.text = String(describing: titles[indexPath.row].vote_average)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return titles.count
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//
//        let selectedMovie = titles[indexPath.row]
//        let detail = DetailViewController()
//        detail.configure(with: selectedMovie)
//
//        self.navigationController?.pushViewController(detail, animated: true)
//
//    }
//}
//


import UIKit
import SnapKit

class MoviesTableViewCell: UITableViewCell {
    
    weak var navigationController: UINavigationController?
    
    private var titles: [Title] = [Title]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 170)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SectionCollectionViewCell.self, forCellWithReuseIdentifier: SectionCollectionViewCell.nameOfClass)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var didSelectItem: ((Title) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func addSubviews() {
        contentView.addSubview(collectionView)
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadMovieWith(model: titles[indexPath.row]) { result in
            switch result {
            case .success():
            NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension MoviesTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCollectionViewCell.nameOfClass, for: indexPath) as? SectionCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let model = titles[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }
        cell.configure(with: model)
        cell.averageLabel.text = String(describing: titles[indexPath.row].vote_average)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let selectedMovie = titles[indexPath.row]
        
        didSelectItem?(selectedMovie)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) {[weak self] _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self?.downloadTitleAt(indexPath: indexPath)
                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}
