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
            usernameLabel.text = user?.username
            setupProfileImage()
        }
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        label.textColor = .darkGray
        return label
    }()
    
    let userInfoLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "email: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\(Auth.auth().currentUser?.email ?? "no email set")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.textAlignment = .left
        return label
    }()
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(userInfoLabel)
        
        usernameLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        userInfoLabel.anchor(top: usernameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
//        setupProfileImage()
    }
    
    fileprivate func setupProfileImage() {
        
        guard let username = user?.username else { return }
        print("Did set user: \(username)")
        guard let userImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: "\(userImageUrl)") else { return }
        
        profileImageView.loadImage(urlString: "\(url)")

        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 2
        //        profileImageView.layer.borderColor = UIColor.rgb(red: 224, green: 57, blue: 62).cgColor
        profileImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
