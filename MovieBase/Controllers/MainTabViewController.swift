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
        let favouritesVC = UINavigationController(rootViewController: FavouritesViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        favouritesVC.tabBarItem.image = UIImage(systemName: "bookmark")
        
        homeVC.title = "Home"
        favouritesVC.title = "Favourites"
        
        tabBar.tintColor = .label
        
        setViewControllers([homeVC, favouritesVC], animated: true)
    }
}

