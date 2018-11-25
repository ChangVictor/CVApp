//
//  MenuHeader.swift
//  CVApp
//
//  Created by Victor Chang on 25/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class MenuHeader: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        let nameLabel = UILabel()
        nameLabel.text = "Victor Chang"
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        let usernameLabel = UILabel()
        usernameLabel.text = "@veectorCH"
        
        let statsLabel = UILabel()
        statsLabel.text = "42 Following 7091 Followers"
        
        let arrangedSubviews = [UIView(), nameLabel, usernameLabel, SpacerView(space: 16), statsLabel]
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
//        stackView.customSpacing(after: usernameLabel)
        addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
