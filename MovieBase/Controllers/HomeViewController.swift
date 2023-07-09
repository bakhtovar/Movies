//
//  HomeViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit
import SnapKit

enum Sections: Int {
    case Popular = 0
    case NowPlaying = 1
    case Upcoming = 2
}

protocol SectionDelegate: AnyObject {
    func didSelectSection(_ section: Int)
}

class HomeViewController: UIViewController {
    
    // MARK: - Data Layer
    var expandedViewController: ExpandedViewController?
    weak var delegate: SectionDelegate?
    private var randomTrendingMovies: Title?
    private var headerView: HeaderUIView?
    let sectionsTitle: [String] = ["Popular", "Now Playing ", "Upcoming"]
    
    
    // MARK: - UI
    private lazy var homeFeedTable: UITableView = {
        let homeFeedTable = UITableView(frame: .zero, style: .grouped)
        homeFeedTable.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.nameOfClass)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        headerView = HeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        return homeFeedTable
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        addSubViews()
        makeConstraints()
        getNowPlayingMovies()
        configureHeaderUIView()
        
//        expandedViewController = ExpandedViewController()
//        expandedViewController?.delegate = self
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        homeFeedTable.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    // MARK: - Private
    private func addSubViews() {
        view.addSubview(homeFeedTable)
    }
    
    
    private func getNowPlayingMovies() {
        APICaller.shared.getNowPlayingMovies { results in
            switch results {
            case .success(let movies):
                print(movies)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureHeaderUIView() {
        APICaller.shared.getNowPlayingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                DispatchQueue.main.async {
                    let selectedTitle = titles.randomElement()
                    self?.randomTrendingMovies = selectedTitle
                    
                    let title = Title(id: selectedTitle?.id ?? 0, media_type: selectedTitle?.media_type, original_name: selectedTitle?.original_name, original_title: selectedTitle?.original_title, poster_path: selectedTitle?.poster_path, overview: selectedTitle?.overview, vote_count: selectedTitle?.vote_count ?? 0, release_date: selectedTitle?.release_date, vote_average: selectedTitle?.vote_average ?? 0.0)
                    
                    self?.headerView?.configure(with: [title])
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.nameOfClass) as? MoviesTableViewCell else {
                return UITableViewCell()
            }
            
            switch indexPath.section {
            case Sections.NowPlaying.rawValue:
                APICaller.shared.getNowPlayingMovies { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case Sections.Popular.rawValue:
                APICaller.shared.getPopularMovies { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            case Sections.Upcoming.rawValue:
                
                APICaller.shared.getUpcomingMovies { result in
                    switch result {
                    case .success(let titles):
                        cell.configure(with: titles)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
                
            default:
                return UITableViewCell()
            }
            
            cell.didSelectItem = { [weak self] selectedMovie, indexPath in
                    let detailViewController = DetailViewController()
                    detailViewController.configureTitle(with: selectedMovie)
                    self?.navigationController?.pushViewController(detailViewController, animated: true)
                }
            
            return cell
        }
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            sectionsTitle.count
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            1
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            200
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            40
        }
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            guard let header = view as? UITableViewHeaderFooterView else { return }
            
            let sectionTitle = sectionsTitle[section]
            let moviesText = "MOVIES"
            let separatorText = " | "
            
            let attributedText = NSMutableAttributedString()
            let sectionTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
                .foregroundColor: UIColor.white
            ]
            let moviesAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.gray.withAlphaComponent(0.7)
            ]
            let separatorAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular),
                .foregroundColor: UIColor.gray.withAlphaComponent(0.7)
            ]
            
            attributedText.append(NSAttributedString(string: sectionTitle, attributes: sectionTitleAttributes))
            attributedText.append(NSAttributedString(string: separatorText, attributes: separatorAttributes))
            attributedText.append(NSAttributedString(string: moviesText, attributes: moviesAttributes))
            
            header.textLabel?.attributedText = attributedText
            
            // Add arrow button
            let arrowButton = UIButton(type: .custom)
            arrowButton.setImage(UIImage(systemName: "arrow.right"), for: .normal)
            arrowButton.addTarget(self, action: #selector(arrowButtonTapped(_:)), for: .touchUpInside)
            arrowButton.tintColor = UIColor.gray.withAlphaComponent(0.7)
            arrowButton.tag = section // Set the tag to identify the section
            header.contentView.addSubview(arrowButton)
            
            // Add constraints for the arrow button using SnapKit
            arrowButton.snp.makeConstraints { make in
                make.trailing.equalTo(header.contentView).offset(-16)
                make.centerY.equalTo(header.contentView)
                make.width.equalTo(20)
                make.height.equalTo(20)
                
                // Instantiate the ExpandedViewControlle
            }
        }

    @objc private func arrowButtonTapped(_ sender: UIButton) {
        let section = sender.tag // Get the section from the tag
        let expandedViewController = ExpandedViewController()
        expandedViewController.index = section
        
        let navigationController = UINavigationController(rootViewController: expandedViewController)
        navigationController.modalPresentationStyle = .fullScreen // Present the navigation controller in full screen
        
        present(navigationController, animated: true, completion: nil)
    }

        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return sectionsTitle[section]
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let defaultOffset = view.safeAreaInsets.top
            let offset = scrollView.contentOffset.y + defaultOffset
            
            navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
        }
    }
