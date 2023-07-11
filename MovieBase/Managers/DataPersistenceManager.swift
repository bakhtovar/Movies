//
//  DataPersistenceManager.swift
//  MovieBase
//
//  Created by Bakhtovar on 07/07/23.
//

import Foundation
import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabasesError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    func downloadMovieWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieItem(context: context)
        
        item.original_title = model.original_title
        item.poster_path = model.poster_path
        item.overview = model.overview
        item.media_type = model.media_type
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        item.release_date = model.release_date
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabasesError.failedToSaveData))
        }
    }
    
    func fetchingMoviesFromDatabase(completion: @escaping (Result<[MovieItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<MovieItem>
        
        request = MovieItem.fetchRequest()
        
        do {
             let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            print(error.localizedDescription)
            completion(.failure(DatabasesError.failedToFetchData))
        }
        
    }
    
    func deleteTitleWith(model: MovieItem, completion: @escaping (Result<Void, Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
            
        } catch {
            completion(.failure(DatabasesError.failedToDeleteData))
        }
    }
    
    func editMovie(model: MovieItem, completion: @escaping (Result<Void, Error>)-> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
            
        } catch {
            completion(.failure(DatabasesError.failedToDeleteData))
        }
    }
}

