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
        let attributedText = NSMutableAttributedString(string: "iOS Development | Tech Enthusiast", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 12)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 3)]))
        attributedText.append(NSAttributedString(string: "Born 8 August 1990", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 12)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 3)]))
        attributedText.append(NSAttributedString(string: "Based in Buenos Aires, Argentina", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 12)]))

        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Victor Chang"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .left
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Business Analyst transitioning into iOS Developer", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 6)]))
        attributedText.append(NSAttributedString(string: "I love the process of building something, the way I want to build it. I constantly strive to learn the newest technologies and best practices.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 13)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .left
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
        
        stackView.anchor(top: personalInfoLabel.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        addSubview(infoLabel)
        addSubview(profileImageView)
        addSubview(personalInfoLabel)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        setupProfileImage()
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 20)
        infoLabel.anchor(top: self.topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: self.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        personalInfoLabel.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 4, paddingLeft: 8, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
        setupSocialMediaBar()
    }
    
    fileprivate func setupProfileImage() {
        profileImageView.layer.cornerRadius = 100 / 2
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

