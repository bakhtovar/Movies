import UIKit
import SnapKit
import SDWebImage

class DetailViewController: UIViewController {
    lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "WebView") // Replace with your own image name
        return imageView
    }()
    
    lazy var movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "WebView") // Replace with your own image name
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.text = "Movie Title"
        return label
    }()
    
    lazy var  releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Release Date"
        return label
    }()
        lazy var averageRatingLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .white
            label.text = "Average Rating: 4.5" // Replace with the actual average rating
            return label
        }()
        
        lazy var descriptionLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = .white
            label.numberOfLines = 0
            label.text = "Movie description goes here" // Replace with the actual movie description
            return label
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.addSubview(backgroundImageView)
            backgroundImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            backgroundImageView.addSubview(movieImageView)
            movieImageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
                make.top.equalToSuperview().offset(150)
                make.width.equalTo(100)
                make.height.equalTo(170)
            }
            
            backgroundImageView.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.leading.equalToSuperview().offset(20)
            }
            
            backgroundImageView.addSubview(releaseDateLabel)
            releaseDateLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(8)
                make.leading.equalTo(titleLabel)
            }
            
            backgroundImageView.addSubview(averageRatingLabel)
            averageRatingLabel.snp.makeConstraints { make in
                make.top.equalTo(releaseDateLabel.snp.bottom).offset(4)
                make.leading.equalTo(titleLabel)
            }
            
            backgroundImageView.addSubview(descriptionLabel)
            descriptionLabel.snp.makeConstraints { make in
                make.top.equalTo(movieImageView.snp.bottom).offset(20)
                make.leading.equalTo(movieImageView)
                make.trailing.equalToSuperview().inset(20)
            }
        }
        
        public func configure(with model: Title) {
            titleLabel.text = model.original_title
            releaseDateLabel.text = "Release Date: \(String(describing: model.release_date))"
            averageRatingLabel.text = "Average Rating: \(model.vote_average)"
            descriptionLabel.text = model.overview
            
            print(titleLabel.text)
            if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
                movieImageView.sd_setImage(with: url, completed: nil)
                backgroundImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }
