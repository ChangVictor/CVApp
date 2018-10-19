//
//  HomePostCell.swift
//  CVApp
//
//  Created by Victor Chang on 11/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

protocol HomePostCellDelegate {
    func didTapComment(post: Post)
    func didLike(for cell: HomePostCell)
}

class HomePostCell: UICollectionViewCell {
    
    var post: Post? {
        didSet {
            
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected@2x.png").withRenderingMode(.alwaysOriginal), for: .normal)
            
            usernameLabel.text = "Username"
            usernameLabel.text = post?.user.username
            
            setupAttributedCaption()
        }
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSAttributedString(string: "\(post.message)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timaAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timaAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
        self.messageTextView.attributedText = attributedText
        
    }
    
   
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "This is a test message"
        textView.isScrollEnabled = false
        return textView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //    let messageLabel: UILabel = {
    //        let label = UILabel()
    //        label.numberOfLines = 0
    //        return label
    //    }()
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
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
        addSubview(messageTextView) 
        addSubview(userProfileImageView)
        addSubview(likeButton)
//        addSubview(messageLabel)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        userProfileImageView.layer.cornerRadius = 50 / 2
        
        messageTextView.anchor(top: self.topAnchor, left: userProfileImageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
