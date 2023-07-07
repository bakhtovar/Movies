import UIKit
import SnapKit
import SDWebImage

class DetailViewController: UIViewController {
    
    lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        //view.layer.shadowRadius = 4
        return view
    }()
    
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
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.numberOfLines = 0
        label.text = "Movie description goes here" // Replace with the actual movie description
        return label
    }()
    
    private lazy var backButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        view.addGestureRecognizer(tapGesture)
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        //button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .yellow
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        makeConstraints()
       // configureNavigationBar()
        addBackButton()
    }
    
    //MARK: - Private
    private func addSubviews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(shadowView)
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
        
        shadowView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(73)
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
//
//    private func configureNavigationBar() {
//        navigationController?.navigationBar.tintColor = .yellow
//        navigationController?.navigationBar.topItem?.title = ""
//    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .yellow
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.backIndicatorImage = UIImage() // Hide the default back button image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage() // Hide the default back button image
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButtonView)
    }
    
//
//    private func addBackButton() {
//         let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
//         navigationItem.leftBarButtonItem = backButton
//         backButton.tintColor = .yellow
//
//         navigationController?.navigationBar.tintColor = .white
//         navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//     }
//
     @objc private func backButtonTapped() {
         navigationController?.popViewController(animated: true)
     }
    
    private func addBackButton() {
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        //navigationItem.hidesBackButton = true
        
        view.addSubview(backButtonView)
        backButtonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(50) // Set the width and height of the backButtonView to 100
        }
        backButtonView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            //make.center.equalToSuperview()
            make.leading.top.equalToSuperview().offset(10)
            make.width.height.equalTo(25)
        }
        backButton.imageView?.contentMode = .scaleAspectFill // Ensure the button's content scales properly
    }
    
    public func configure(with model: Title) {
        titleLabel.text = model.original_title
        descriptionLabel.text = model.overview
        
        let formattedDate = formatDate(model.release_date)
        let rating = String(format: "%.1f", model.vote_average)
        let combinedText = "\(formattedDate) - \(rating) ⭐️"
        let attributedText = NSAttributedString(string: combinedText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)
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

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
