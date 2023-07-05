//
//  APICaller.swift
//  MovieBase
//
//  Created by Bakhtovar on 05/07/23.
//

import Foundation

struct Constants {
    static let API_KEY = "5b5afe99215d8dad2270a64371913c4d"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIError: Error {
    case failedTogetData
}

class APICaller {
    static let shared = APICaller()
    
    func getNowPlayingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/now_playing?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        
        print(url)
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
            }
            catch {
                completion(.failure(APIError.failedTogetData))
                print(error.localizedDescription)
            }
        }
        
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            }
            catch {
                completion(.failure(APIError.failedTogetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
        
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1") else {return}
        print(url)
        print("popular_url")
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
                
            }
            catch {
                completion(.failure(APIError.failedTogetData))
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
