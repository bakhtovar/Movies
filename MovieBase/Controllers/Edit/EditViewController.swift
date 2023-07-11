//
//  EditViewController.swift
//  MovieBase
//
//  Created by Bakhtovar on 11/07/23.
//

import UIKit

class EditViewController: UIViewController {

     lazy var titleLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.backgroundColor = .white
        label.text = "Movie Title"
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
 
     lazy var descriptionLabel: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black.withAlphaComponent(0.7)
        label.backgroundColor = .white
        label.text = "Movie description goes here"
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        return label
    }()
    
    lazy var editButton: UIButton = {
           let button = UIButton()
           button.backgroundColor = .red
           button.layer.cornerRadius = 20
           button.setTitle("Save", for: .normal)
           button.setTitleColor(.white, for: .normal)
           button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
           return button
    }()
    
    @objc private func editButtonTapped() {
        updateInfo(movieItem: movieItem)
        navigationController?.popViewController(animated: true)
    }
    //init
    private let movieItem: MovieItem
    
    init(movieItem: MovieItem) {
        self.movieItem = movieItem
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("failed to init")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isTranslucent = false
        addSubviews()
        makeConstraints()
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
    }
    
    private func updateInfo(movieItem: MovieItem) {
       // guard let movieItem = movieItem else { return }
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        movieItem.original_title = titleLabel.text
        movieItem.overview = descriptionLabel.text

        do {
            try context.save()
            print("Item updated successfully")
        } catch {
            print("Error updating item: \(error)")
        }
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(editButton)
    }
    
    private func makeConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(200)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(400)
            make.height.equalTo(100)
        }
        
        editButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
    }
    
    private func configureViews() {
         titleLabel.text = movieItem.original_title
         descriptionLabel.text = movieItem.overview
    }
 
}
