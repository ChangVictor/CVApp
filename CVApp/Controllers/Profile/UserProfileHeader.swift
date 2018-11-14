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
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Email: ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\(Auth.auth().currentUser?.email ?? "no email set")", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .left
//        label.text = "email: \(Auth.auth().currentUser?.email ?? "no email set")"
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        addSubview(profileImageView)
        addSubview(userNameLabel)
        
        userNameLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
        setupProfileImage()
    }
    
    fileprivate func setupProfileImage() {
        
        print("Did set user: \(user?.username ?? "no user set")")
        guard let profileImageUrl = Auth.auth().currentUser?.photoURL else { return }
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
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        //        profileImageView.layer.borderColor = UIColor.rgb(red: 224, green: 57, blue: 62).cgColor
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
