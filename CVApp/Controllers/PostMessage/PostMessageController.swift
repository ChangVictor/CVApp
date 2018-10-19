//
//  PostMessageController.swift
//  CVApp
//
//  Created by Victor Chang on 18/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class PostMessageController: UIViewController {
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            
            let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + post.message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributedText
//            profileImageView.loadImage(urlString: post.user.profileImageUrl)

        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
    }
    
}
