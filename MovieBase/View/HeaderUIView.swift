//  HeaderUIView.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit
import SnapKit
import SDWebImage

class HeaderUIView: UIView {

    // MARK: - UI
    private lazy var heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
       // imageView.image = UIImage(named: "WebView")
        return imageView
    }()

    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        makeConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
        return
        }

        print(url)
        print("url")
        heroImageView.sd_setImage(with: url, completed: nil)
    }

    // MARK: - Constraints
    private func makeConstraints() {

        heroImageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }

    // MARK: - Private
    private func addSubviews() {
        addSubview(heroImageView)
    }
}
