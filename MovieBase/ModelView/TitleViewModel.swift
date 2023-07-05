//
//  TitleViewModel.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import Foundation

struct TitleViewModel: Codable {
    let titleName: String
    let posterURL: String
}

struct PhotosModel: Codable {
    let photos: [TitleViewModel]
}
