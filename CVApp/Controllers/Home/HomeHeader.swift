//
//  HomeHeader.swift
//  CVApp
//
//  Created by Victor Chang on 11/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class HomeHeader: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "wood_camera"))
        iv.contentMode = .scaleAspectFill
        
        return iv
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let containerView: UIView = {
        let coverImage = "cloth_macbook"
        let view = UIImageView()
        let logoImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.backgroundColor = .gray
            return imageView
        }()
        
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 105, height: 105)
        logoImageView.layer.cornerRadius = 105 / 2
        print("\(logoImageView.widthAnchor)")
        logoImageView.layer.masksToBounds = true
        //        logoImageView.layer.borderColor = UIColor.rgb(red: 253, green: 92, blue: 99).cgColor
        logoImageView.layer.borderColor = UIColor.black.cgColor
        logoImageView.layer.borderWidth = 2.5
        logoImageView.clipsToBounds = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 40).isActive = true
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        //        view.backgroundColor = UIColor.init(patternImage: (coverImage ?? nil)!.withRenderingMode(.alwaysOriginal))
        view.image = UIImage(named: coverImage)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        logoImageView.image = UIImage(named: "VictorMemoji630x630")
        logoImageView.contentMode = .center
        logoImageView.contentMode = .scaleAspectFill
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        addSubview(containerView)
//        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addSubview(imageView)
        imageView.fillSuperview()
        imageView.addSubview(logoImageView)
        
        setupLogoView()
        
    }
    
    fileprivate func setupLogoView() {
        logoImageView.anchor(top: nil, left: nil, bottom: imageView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 105, height: 105)
        logoImageView.layer.cornerRadius = 105 / 2
        print("\(logoImageView.widthAnchor)")
        logoImageView.layer.masksToBounds = true
        //        logoImageView.layer.borderColor = UIColor.rgb(red: 253, green: 92, blue: 99).cgColor
        logoImageView.layer.borderColor = UIColor.black.cgColor
        logoImageView.layer.borderWidth = 2.5
        logoImageView.clipsToBounds = true
        logoImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        logoImageView.image = UIImage(named: "VictorMemoji630x630")
        logoImageView.contentMode = .center
        logoImageView.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
