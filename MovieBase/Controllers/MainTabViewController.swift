//
//  MainTabViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

class MainTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
        view.backgroundColor = .systemBackground
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let favouritesVC = UINavigationController(rootViewController: FavouritesViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        favouritesVC.tabBarItem.image = UIImage(systemName: "bookmark")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        
        homeVC.title = "Home"
        favouritesVC.title = "Favourites"
        searchVC.title = "Search"
        
        tabBar.tintColor = .label
        setViewControllers([homeVC, searchVC, favouritesVC], animated: true)
    }
}

