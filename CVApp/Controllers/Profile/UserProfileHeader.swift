//
//  UserProfileHeader.swift
//  CVApp
//
//  Created by Victor Chang on 21/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookCore

class UserProfileHeader: UICollectionViewCell {
    
    var user: User? {
        didSet {
            setupProfileImage()
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        profileImageView.layer.borderColor = UIColor.rgb(red: 240, green: 240, blue: 240).cgColor
        
    }
    
    fileprivate func setupProfileImage() {
        // TODO: - REFACTOR THIS
        print("Did set user: \(user?.username ?? "no user set")")
        if let profileImageUrl = user?.profileImageUrl {
        
            guard let url = URL(string: "\(profileImageUrl)") else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // check for error & construc image using data
                if let error = error {
                    print("Failed to fetch profile image: ", error)
                    return
                }
                // could check for response 200 (HTTP OK)
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
                }.resume()
            
        } else if let profileImageUrl = Auth.auth().currentUser?.photoURL {
            guard let url = URL(string: "\(profileImageUrl)") else { return }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                // check for error & construc image using data
                if let error = error {
                    print("Failed to fetch profile image: ", error)
                    return
                }
                // could check for response 200 (HTTP OK)
                guard let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
                }.resume()
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
