//
//  SectionCollectionViewCell.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class SectionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var averageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.layer.cornerCurve = .continuous
        return label
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
    
    // MARK: - Private
    private func addSubviews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(averageLabel)
        
    }
    
    // MARK: - Constraints
    override func updateConstraints() {
        posterImageView.snp.updateConstraints() { make in
            make.size.equalToSuperview()
        }
        
        averageLabel.snp.makeConstraints { make in
              make.top.equalToSuperview().offset(8)
              make.trailing.equalToSuperview().offset(-8)
              make.width.equalTo(25)
          }
        
        super.updateConstraints()
    }
}
