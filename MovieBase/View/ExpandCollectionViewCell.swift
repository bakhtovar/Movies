//
//  ExpandCollectionViewCell.swift
//  MovieBase
//
//  Created by Bakhtovar on 06/07/23.
//

import UIKit
import SnapKit
import SDWebImage
import Kingfisher

class ExpandCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Data Layer
    public var titles: [Title] = [Title]()
        
    // MARK: - UI
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
     
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
   
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
//    public func configure(with titles:[Title]) {
//        self.titles = titles
//        
//        }
    
    // MARK: - Constraints
    override func updateConstraints() {
        posterImageView.snp.updateConstraints() { make in
            make.size.equalToSuperview()
        }
        super.updateConstraints()
    }
    
    // MARK: - Private
    private func addSubviews() {
        contentView.addSubview(posterImageView)
    }
}
