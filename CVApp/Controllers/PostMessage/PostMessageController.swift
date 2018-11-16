//
//  PostMessageController.swift
//  CVApp
//
//  Created by Victor Chang on 18/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookCore

class PostMessageController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var user: User? {
        didSet {
            setupProfileImage()
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
        imageView.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
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
        
        navigationController?.navigationBar.prefersLargeTitles = true
        textView.delegate = self
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.title = "Leave a comment"
        setupNavigationButton()
        setupConstrains()
//        setupProfileImage()
        fetchUser()
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
    
    static let updateFeedNotificationName = NSNotification.Name(rawValue: "UptadeFeed")

    fileprivate func setupNavigationButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done
            , target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(handlePost))
    }
    
    @objc fileprivate func handlePost() {
        
        print("Trying to insert post into Firebase")
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let message = textView.text else { return }
        let values = ["message": message,
                      "creationDate": Date().timeIntervalSince1970,
                      "uid": uid
                      ] as [String: Any]
        
        let userPostRef = Database.database().reference().child("posts")
        let ref = userPostRef.child(uid).childByAutoId()
        
        ref.updateChildValues(values) { (error, reference) in
        
            if let error = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to inser post: ", error)
                return
            }
            print("Succesfully inserted post: \(self.textView.text ?? "No post")")
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: PostMessageController.updateFeedNotificationName, object: nil)

        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setupProfileImage() {
        
        guard let username = user?.username else { return }
        print("Did set user: \(username)")
        guard let userImageUrl = user?.profileImageUrl else { return }
        guard let url = URL(string: "\(userImageUrl)") else { return }
        
        profileImageView.loadImage(urlString: "\(url)")

        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.masksToBounds = true
    }
    
    fileprivate func fetchUser() {
        if FBSDKProfile.current() != nil {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let username = Auth.auth().currentUser?.displayName else { return }
            guard let profileImageUrl = Auth.auth().currentUser?.photoURL else { return }
            
            self.user = User(uid: uid, dictionary: ["uid": uid,
                                                    "username": username,
                                                    "profileImageUrl": profileImageUrl as Any])
            
            
        } else {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                
                self.user = User(uid: uid, dictionary: dictionary)
                
            }) { (error) in
                print("Failed to fetch user", error)
            }
        }
    }
}

extension PostMessageController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            
            textView.text = "Enter Message..."
            textView.textColor = UIColor.lightGray
            textView.isPagingEnabled = false
            
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
