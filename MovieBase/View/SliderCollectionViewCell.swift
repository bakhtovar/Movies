//
//  SliderCollectionViewCell.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .green
        setNeedsUpdateConstraints()
        setupUI()
        addSubviews()
        setNeedsUpdateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.layer.cornerCurve = .continuous
    }
    
    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
    
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
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
