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
        let imageView = CustomImageView()
        imageView.backgroundColor = .gray
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Victor Chang"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "Victor's Biography here...\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "Insert some text in here", attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray, kCTFontAttributeName as NSAttributedString.Key: UIFont.systemFont(ofSize: 14)]))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
