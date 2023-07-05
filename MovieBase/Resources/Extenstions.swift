//
//  Extenstions.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import Foundation
import UIKit
import Kingfisher

extension String {
    func capitalizeFirstLetter()-> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

extension UIImageView {
    
    func load(from urlString: String, completion: ((UIImage?) -> Void)? = nil) {
        if let url = URL(string: "https://image.tmdb.org/t/p/w500/\(urlString)") {
            self.kf.setImage(with: url, options: [.transition(.fade(0.1))], completionHandler: { result in
                DispatchQueue.main.async {
                    if case .success(let image) = result {
                        completion?(image.image)
                    } else {
                        completion?(nil)
                    }
                }
            })
        }
    }
}

extension NSObject {
    
    class var nameOfClass: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
