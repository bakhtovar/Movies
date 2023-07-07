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
    
    lazy var releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
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
        addSubviews()
        makeConstraints()
    }
    
    //MARK: - Private
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        view.addSubview(movieImageView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(averageRatingLabel)
        view.addSubview(descriptionLabel)
    }
    
    private func makeConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        movieImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(150)
            make.width.equalTo(100)
            make.height.equalTo(170)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom).offset(20)
            make.leading.equalTo(movieImageView.snp.trailing).offset(20)
        }
        
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(movieImageView.snp.bottom).offset(20)
            make.leading.equalTo(movieImageView)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    public func configure(with model: Title) {
        titleLabel.text = model.original_title
        descriptionLabel.text = model.overview
        
        let formattedDate = formatDate(model.release_date)
        let rating = String(format: "%.1f", model.vote_average)
        let combinedText = "\(formattedDate) - \(rating) ⭐️"
        let attributedText = NSAttributedString(string: combinedText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.gray.withAlphaComponent(0.7)
        ])
        releaseDateLabel.attributedText = attributedText
        
        if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w1280/\(posterPath)") {
            backgroundImageView.sd_setImage(with: url, completed: nil)
        }
        
        if let posterPath = model.poster_path, let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") {
            movieImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    private func formatDate(_ dateString: String?) -> String {
        guard let dateString = dateString else {
            return "Unknown"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "MMM yyyy"
            return formatter.string(from: date)
        }
        
        return "Unknown"
    }}
