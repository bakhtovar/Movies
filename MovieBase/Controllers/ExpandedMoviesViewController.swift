//
//  ExpandedMoviesViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import UIKit

import UIKit

class ExpandedViewController: UIViewController, SectionDelegate {
    func didSelectSection(_ section: Int) {
        print(section)
        print("received section")
    }
    
    private let movies: [Title] = []
    
    var section: Int = 0
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Implement your logic for the expanded view controller here
        // You can access the selected movies using the `movies` property
        print(section)
        print("received")
    }
}
