//
//  HomeHeader.swift
//  CVApp
//
//  Created by Victor Chang on 11/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class HomeHeader: UICollectionViewCell {
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
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        logoImageView.image = UIImage(named: "VictorChang")
        logoImageView.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
