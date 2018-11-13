//
//  VictorHeader.swift
//  CVApp
//
//  Created by Victor Chang on 01/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class VictorProfileHeader: UICollectionViewCell {
    
    var webViewDelegate : WebViewDelegate?
    var url: String?
    
    let profileImageView: CustomImageView = {
        let victorProfile = "victor_profile"
        let imageView = CustomImageView()
        imageView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        imageView.image = UIImage(named: victorProfile)
        return imageView
    }()
    
    let personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "Born 8 August 1990 /n Based in Buenos Aires"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
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
        attributedText.append(NSAttributedString(string: "Constantly striving to learn new technologies and good practices in order to create nice appealing UI while writing highly readable clean code.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 14)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var linkedinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "linkedin.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleButtonLink), for: .touchUpInside)
        return button
    }()
    lazy var instagramButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "instagram.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleButtonLink), for: .touchUpInside)
        return button
    }()
    lazy var githubButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "github.png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleButtonLink), for: .touchUpInside)
        return button
    }()
    lazy var websiteButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(#imageLiteral(resourceName: "browser .png").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleButtonLink), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleButtonLink(_ sender: UIButton?) {
        
        print("webView button triggered")
        if sender == githubButton {
            url = "https://www.github.com/ChangVictor/"
        } else if sender == linkedinButton {
            url = "https://www.linkedin.com/in/victorchangyu/"
        } else if sender == instagramButton {
            url = "https://www.instagram.com/veectorch/"
        } else {
            url = "https://victorchangyu.com/"
        }
        
        webViewDelegate?.toWebPage(url:url)

    }

    fileprivate func setupSocialMediaBar() {
        
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        
        let stackView = UIStackView(arrangedSubviews: [githubButton, linkedinButton, instagramButton, websiteButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(profileImageView)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 110, height: 110)
        setupProfileImage()
        
        nameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        infoLabel.anchor(top: nameLabel.bottomAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        setupSocialMediaBar()
    }
    
    fileprivate func setupProfileImage() {
        profileImageView.layer.cornerRadius = 110 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
//        profileImageView.layer.borderColor = UIColor.rgb(red: 224, green: 57, blue: 62).cgColor
        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 2.5
        profileImageView.contentMode = .scaleAspectFill
        //        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

