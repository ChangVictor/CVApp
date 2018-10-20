//
//  PostMessageController.swift
//  CVApp
//
//  Created by Victor Chang on 18/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class PostMessageController: UIViewController {
    
    var user: User? {
        didSet {
            
            guard let profileImageUrl = user?.profileImageUrl else { return }
            profileImageView.loadImage(urlString: profileImageUrl)
            
        }
    }
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            
            let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
            attributedText.append(NSAttributedString(string: " " + post.message, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
            textView.attributedText = attributedText
            profileImageView.loadImage(urlString: post.user.profileImageUrl)
            
        }
    }
    
    let profileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.lightGray
        return imageView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.text = "Enter message..."
        textView.textColor = .lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)

        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.title = "Comment"
        setupNavigationButton()
        setupConstrains()
        
    }
    
    fileprivate func setupConstrains() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        containerView.addSubview(profileImageView)
        profileImageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: profileImageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain
            , target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePost))
    }
    
    @objc fileprivate func handlePost() {
        print("Trying to insert post into Firebase")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let value = ["message": textView.text,
                     "creationDate": Date().timeIntervalSince1970,
        "uid": uid] as [String: Any]
        
        Database.database().reference().child("posts").childByAutoId().updateChildValues(value) { (error, reference) in
            
            if let error = error {
                print("Failed to inser post: ", error)
                return
            }
            
            print("Succesfully inserted post: ")
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension PostMessageController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = "Enter Message..."
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
    
        else {
            return true
        }

        return false
    }
}
