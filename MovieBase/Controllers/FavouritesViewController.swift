//
//  FavouritesViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    private var titles: [MovieItem] = [MovieItem]()

    private var isSearchActive = false
        // MARK: - UI
    private lazy var favouritesTable: UITableView = {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Favorites"
        view.addSubview(favouritesTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.delegate = self
        makeConstraints()
        self.fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Favourites"
        view.backgroundColor = .systemBackground
        fetchLocalStorageForDownload()
    }
    
    // MARK: - Constraints
    private func makeConstraints() {
        favouritesTable.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
    
    private func fetchLocalStorageForDownload() {
        DataPersistenceManager.shared.fetchingMoviesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.favouritesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableCell.nameOfClass, for: indexPath) as? FavouriteTableCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_name ?? title.original_title ?? "" , posterURL: title.poster_path ?? "")
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row] ) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = titles[indexPath.row]
        let detailViewController = DetailViewController(movieItem: selectedMovie)
        detailViewController.configureMovie(with: selectedMovie)
        detailViewController.status = 1
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FavouritesViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let filteredTitles = titles.filter { title in
                return title.original_name?.localizedCaseInsensitiveContains(searchText) ?? false ||
                    title.original_title?.localizedCaseInsensitiveContains(searchText) ?? false
            }
            self.titles = filteredTitles
            isSearchActive = true
        } else {
            self.fetchLocalStorageForDownload()
            isSearchActive = false
        }
        favouritesTable.reloadData()
    }
}

extension FavouritesViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        if !isSearchActive {
            fetchLocalStorageForDownload()
        }
    }
}
