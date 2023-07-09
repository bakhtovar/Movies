//
//  SearchViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 09/07/23.
//


import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Data Layer
    private var titles: [Title] = [Title]()
    
    // MARK: - UI
    private lazy var searchTable: UITableView = {
        let table = UITableView()
        table.register(FavouriteTableCell.self, forCellReuseIdentifier: FavouriteTableCell.nameOfClass)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search for a Movie"
        controller.searchBar.searchBarStyle = .minimal
        controller.searchResultsUpdater = self
        return controller
    }()
    
    // MARK: - Properties
    private var isSearchControllerActive: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        view.addSubview(searchTable)
        makeConstraints()
        fetchSearchMovies()
    }
    
    // MARK: - Private
    private func fetchSearchMovies() {
        APICaller.shared.getSearchMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        searchTable.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableCell.nameOfClass, for: indexPath) as? FavouriteTableCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let detailViewController = DetailViewController()
        let selectedMovie = self.titles[indexPath.row]
        detailViewController.configureTitle(with: selectedMovie)
        
        if isSearchControllerActive {
            searchController.dismiss(animated: true) {
                self.navigationController?.pushViewController(detailViewController, animated: true)
            }
        } else {
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else {
            isSearchControllerActive = false
            return
        }
        
        isSearchControllerActive = true
        
        APICaller.shared.search(with: query)  { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    self?.titles = titles
                    self?.searchTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
