//
//  HomeController.swift
//  CVApp
//
//  Created by Victor Chang on 09/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    private let messages = ["message 1", "message 2", "message 3"]
    private var tableView: UITableView!
    private var cellId = "cellId"
    
    let containerView: UIView = {
        let view = UIView()
        let logoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .gray
            return imageView
        }()
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        logoImageView.layer.cornerRadius = 150 / 2
        logoImageView.layer.masksToBounds = true
        logoImageView.layer.borderColor = UIColor.white.cgColor
        logoImageView.layer.borderWidth = 2
        logoImageView.clipsToBounds = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 70).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(containerView)
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        
        setupTableView()
       
        
    }
    
    fileprivate func setupTableView() {

        tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.dataSource = self
        tableView.delegate = self
        self.view.addSubview(tableView)

        tableView.anchor(top: containerView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 130, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath as IndexPath)
        cell.textLabel?.text = "\(messages[indexPath.row])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(messages[indexPath.row])")
    }
    
}
