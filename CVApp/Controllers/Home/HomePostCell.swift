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
    
//    var user: User? {
//        didSet {
//            guard let profileImageUrl = user?.profileImageUrl else { return }
//
//            userProfileImageView.loadImage(urlString: profileImageUrl)
//        }
//    }
    
    var post: Post? {
        didSet {
            
            guard let profileImageUrl = post?.user.profileImageUrl else { return }

            
            likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
            
            userProfileImageView.loadImage(urlString: profileImageUrl)

            setupAttributedCaption()
//            usernameLabel.text = post?.user.username
//            messageLabel.text = post?.message
        }
    }
    
    fileprivate func setupAttributedCaption() {
        
        guard let post = self.post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])

        attributedText.append(NSAttributedString(string: " \(post.message)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        
        let timaAgoDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timaAgoDisplay, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.gray]))
        
//        self.messageTextView.attributedText = attributedText
            self.messageLabel.attributedText = attributedText
    }
    
   
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.isSelectable = false
        textView.isEditable = false
        return textView
    }()
    
    let messageLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)

        return label
    }()
    
    
    
    let bubbleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.contentMode = .center
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
//        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
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
        
        addSubview(bubbleBackgroundView)
        addSubview(usernameLabel)
//        addSubview(messageTextView)
        addSubview(userProfileImageView)
        addSubview(likeButton)
        addSubview(messageLabel)

        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 18, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40 / 2
        
        usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        messageLabel.anchor(top: usernameLabel.bottomAnchor, left: userProfileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 4, paddingBottom: 20, paddingRight: 24, width: 0, height: 0)
        
        bubbleBackgroundView.anchor(top: usernameLabel.topAnchor, left: leftAnchor, bottom: messageLabel.bottomAnchor, right: rightAnchor, paddingTop: -10, paddingLeft: 12, paddingBottom: -10, paddingRight: 12, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
