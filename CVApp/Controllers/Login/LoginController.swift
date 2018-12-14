//
//  LoginController.swift
//  CVApp
//
//  Created by Victor Chang on 12/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation
import Firebase
import FacebookLogin
import FBSDKLoginKit
import GoogleSignIn

class  LoginController: UIViewController, GIDSignInUIDelegate {

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
   
    @objc fileprivate func handleTextInputChange() {
        print("handleTextInputChange Triggered")
        let isFormValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor(red: 224/255, green: 57/255, blue: 62/255, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor(red: 224/255, green: 57/255, blue: 62/255, alpha: 0.5)
        }
    }
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.isEnabled = false
        button.backgroundColor = UIColor(red: 224/255, green: 57/255, blue: 62/255, alpha: 0.5)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self  , action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleLogin() {
        print("Login Triggered")
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print("Failed to sign in with email: ", error)
                return
            }
            print("Succesfully logged in with user: ", Auth.auth().currentUser?.uid ?? "Username not found")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    let fbLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with Facebook", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 59, green: 89, blue: 152)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleFacebookLogin() {
        
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                print("Loggin in")
                self.handleFBSDK()
            case .failed(let error):
                print("Failed login: \(error.localizedDescription)")
            case .cancelled:
                print("Login Cancelled")
            }
        }
        /*
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
    
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accesToken = FBSDKAccessToken.current() else {
                print("Failed to get acces token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accesToken.tokenString)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                
                guard let uid = Auth.auth().currentUser?.uid else { return }
                let ref = Database.database().reference()
                ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.hasChild(uid) {
                        
                        print("Succesfully logged in with user: ", Auth.auth().currentUser?.displayName ?? "Username not found")
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        mainTabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                        
                    } else {
                        
                        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(480).height(480)"])?.start { (connection, result, error) in
                            if error != nil {
                                print("Graph failed: ", error ?? "")
                                return
                            }
                            print(result ?? "")
                            guard let data = result as? [String: Any] else { return }
                            guard let email = data["email"] as? String else { return }
                            guard let username = data["name"] as? String else { return }
                            if let profilePictureUrl = ((data["picture"] as? [String: Any])? ["data"] as? [String: Any])? ["url"] as? String {
                                print(profilePictureUrl)
                                guard let url = URL(string: profilePictureUrl) else { return }
                                guard let data = NSData(contentsOf: url) else { return }
                                guard let uid = Auth.auth().currentUser?.uid else { return }
                                let image = UIImage(data: data as Data)
                                guard let uploadData = image?.jpegData(compressionQuality: 0.4) else { return }
                                Storage.storage().reference().child("profile_images").child(uid).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                    if let error = error {
                                        print("Failed to save facebook profile picture on storage", error)
                                        return
                                    }
                                    Storage.storage().reference().child("profile_pictures").child(uid).downloadURL(completion: { (downloadUrl, error) in
                                        guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                                        print("Succesfully uploaded profile image", profileImageUrl)
                                        
                                    })
                                })
                                
                                let userInfo: [String: Any] = ["uid": uid,
                                                               "username": username,
                                                               "email": email,
                                                               "profileImageUrl": profilePictureUrl
                                ]
                                let values = [uid: userInfo]
                                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                                    if let error = error {
                                        print("Failed top save Facebook user into database", error)
                                        return
                                    }
                                    
                                    print("Succesfully saved Facebook user into Database", reference)
                                    
                                })  
                            }
                        }
                        guard let maintabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        maintabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            })
        }  */
    }
    
    fileprivate func handleFBSDK() {
        
        guard let accesToken = FBSDKAccessToken.current() else {
            print("Failed to get acces token")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accesToken.tokenString)
        Auth.auth().signInAndRetrieveData(with: credential, completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
        }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let ref = Database.database().reference()
            ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(uid) {
                    
                    print("Succesfully logged in with user: ", Auth.auth().currentUser?.displayName ?? "Username not found")
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                        
                        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.width(480).height(480)"])?.start { (connection, result, error) in
                            if error != nil {
                                print("Graph failed: ", error ?? "")
                                return
                            }
                            print(result ?? "")
                            guard let data = result as? [String: Any] else { return }
                            guard let email = data["email"] as? String else { return }
                            guard let username = data["name"] as? String else { return }
                            if let profilePictureUrl = ((data["picture"] as? [String: Any])? ["data"] as? [String: Any])? ["url"] as? String {
                                print(profilePictureUrl)
                                guard let url = URL(string: profilePictureUrl) else { return }
                                guard let data = NSData(contentsOf: url) else { return }
                                guard let uid = Auth.auth().currentUser?.uid else { return }
                                let image = UIImage(data: data as Data)
                                guard let uploadData = image?.jpegData(compressionQuality: 0.4) else { return }
                                Storage.storage().reference().child("profile_images").child(uid).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                                    if let error = error {
                                        print("Failed to save facebook profile picture on storage", error)
                                        return
                                    }
                                    Storage.storage().reference().child("profile_pictures").child(uid).downloadURL(completion: { (downloadUrl, error) in
                                        guard let profileImageUrl = downloadUrl?.absoluteString else { return }
                                        print("Succesfully uploaded profile image", profileImageUrl)
                                        
                                    })
                                })
                                
                                let userInfo: [String: Any] = ["uid": uid,
                                                               "username": username,
                                                               "email": email,
                                                               "profileImageUrl": profilePictureUrl
                                ]
                                let values = [uid: userInfo]
                                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                                    if let error = error {
                                        print("Failed top save Facebook user into database", error)
                                        return
                                    }
                                    
                                    print("Succesfully saved Facebook user into Database", reference)
                                    
                                })
                            }
                        }
                        guard let maintabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                        maintabBarController.setupViewControllers()
                        self.dismiss(animated: true, completion: nil)
                    }
            })
        })
    }
    
    let googleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login with Google", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 214, green: 45, blue: 32)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleGoogleLogin() {
        print("Google login not yet set")
        
        
        GIDSignIn.sharedInstance().signIn()
        
//        guard let maintabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
//        maintabBarController.setupViewControllers()
//        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func googleLoginHandler() {
        
    }
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleShowSignUp() {
        print("SignUp Button Triggered")
        let signUpController = SignUpController()
        self.present(signUpController, animated: true, completion: nil)
        
    }
    
    fileprivate func signInWithFacebook() {
        guard let accesToken = FBSDKAccessToken.current() else {
            print("Failed to get acces token")
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().signIn()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationController?.isNavigationBarHidden = true
        
        view.addSubview(loginButton)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 12, paddingRight: 0, width: 0, height: 50)
        
//        let fbloginButton = LoginButton(readPermissions: [ .publicProfile ])

//        loginButton.center = view.center
//        view.addSubview(fbloginButton)
//        fbloginButton.center = view.center
        
        if let accesToken = FBSDKAccessToken.current() {
            print(accesToken)
        }
        
        setupInputFields()
//        fbloginButton.anchor(top: loginButton.bottomAnchor, left: loginButton.leftAnchor, bottom: nil, right: loginButton.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
//        fbloginButton.layer.cornerRadius = 5
        
    }
    
    fileprivate func setupInputFields() {
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, fbLoginButton, googleLoginButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 200, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 240)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

}
