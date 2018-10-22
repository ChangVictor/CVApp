//
//  UserProfileCell.swift
//  CVApp
//
//  Created by Victor Chang on 21/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit


class UserProfileCell: UICollectionViewCell {
    
    let messageLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 14)
    label.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    return label
    }()
    
    let usernameLabel: UILabel = {
    let label = UILabel()
    label.text = "Username"
    label.font = UIFont.boldSystemFont(ofSize: 14)
    return label
    }()
    
    let userProfileImageView: CustomImageView = {
    let imageView = CustomImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.backgroundColor = .lightGray
    return imageView
    }()
    
    lazy var likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
    return button
    }()
    
    @objc fileprivate func handleLike() {
    print("Handling like for comment")
    }
    
    override init(frame: CGRect) {
    
    super.init(frame: frame)
    
    addSubview(usernameLabel)
    addSubview(userProfileImageView)
    addSubview(likeButton)
    addSubview(messageLabel)

    
        messageLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
    }
    
}


