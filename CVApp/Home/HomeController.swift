//
//  HomeController.swift
//  CVApp
//
//  Created by Victor Chang on 09/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let containerView: UIView = {
        let view = UIView()
        
//        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
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
       
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
