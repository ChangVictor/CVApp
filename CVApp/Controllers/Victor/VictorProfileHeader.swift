//
//  VictorHeader.swift
//  CVApp
//
//  Created by Victor Chang on 01/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class VictorProfileHeader: UICollectionViewCell {
    
    let profileImageView: CustomImageView = {
        let victorProfile = "victorProfile"
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        imageView.image = UIImage(named: victorProfile)
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Victor Chang"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Former Business Analyst transitioning into iOS Developer", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "Insert some text in here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 120, height: 120)
        setupProfileImage()
        
        nameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        infoLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        
    }
    
    fileprivate func setupProfileImage() {
        profileImageView.layer.cornerRadius = 120 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.rgb(red: 224, green: 57, blue: 62).cgColor
        profileImageView.layer.borderWidth = 3
        profileImageView.contentMode = .scaleAspectFill
        //        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
