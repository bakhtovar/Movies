//
//  SliderCollectionViewCell.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFill
           imageView.clipsToBounds = true
           return imageView
       }()
       
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupSubviews()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       private func setupSubviews() {
           contentView.addSubview(imageView)
           imageView.snp.makeConstraints { make in
               make.edges.equalToSuperview()
           }
       }
}
