//
//  MoviesTableViewCell.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class MoviesTableViewCell: UITableViewCell {
    
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        addSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with titles:[Title]) {
        self.titles = titles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {[weak self] in
                self?.collectionView.reloadData()
                }
            }
    
    // MARK: - Private
    private func addSubviews() {
        contentView.addSubview(collectionView)
    }
    
    // MARK: - Constraints
    override func updateConstraints() {
        collectionView.snp.updateConstraints { make in
            make.edges.equalToSuperview()
        }
         super.updateConstraints()
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
        print("count")
        print(titles.count)
       return titles.count
       
    }
}
