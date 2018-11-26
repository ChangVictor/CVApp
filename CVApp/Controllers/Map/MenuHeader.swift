//
//  MenuHeader.swift
//  CVApp
//
//  Created by Victor Chang on 25/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class MenuHeader: UICollectionViewCell {
    let nameLabel = UILabel()
    let usernameLabel = UILabel()
    let profileImageView = ProfileImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupComponents()
        
        setupStackView()
    }
    
    fileprivate func setupStackView() {
        let arrangedSubviews = [
                                UIStackView(arrangedSubviews: [profileImageView, UIView()]),
//                                profileImageView,
                                nameLabel,
                                SpacerView(space: 8),
                                usernameLabel
                                ]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 12, right: 12)
        //        stackView.customSpacing(after: usernameLabel)
        addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupComponents() {
        nameLabel.text = "Victor Chang"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        usernameLabel.text = "Explore Victor's Places!"
        profileImageView.image = #imageLiteral(resourceName: "VictorMemoji630x630")
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 45 / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
