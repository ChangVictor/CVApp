//
//  MainTabBarController.swift
//  CVApp
//
//  Created by Victor Chang on 09/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    var handler: AuthStateDidChangeListenerHandle?
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            let postMessageViewController = PostMessageController()
            let navController = UINavigationController(rootViewController: postMessageViewController)
            
            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            self.checkLoggedInUserStatus()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let handler = handler else { return }
        Auth.auth().removeStateDidChangeListener(handler)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        setupViewControllers()
    }
    
        func setupViewControllers() {
            
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: StrechyHeaderLayout()))
            
        let victorNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "V_icon"), selectedImage: #imageLiteral(resourceName: "V_icon"), rootViewController: VictorProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
            
        let postMessageController = templateNavController(unselectedImage: #imageLiteral(resourceName: "send2"), selectedImage: #imageLiteral(resourceName: "send2"), rootViewController: PostMessageController())
        
        let mapNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "location_unselected"), selectedImage: #imageLiteral(resourceName: "location_selected"), rootViewController: MapController())
        
            let profileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           victorNavController,
                           postMessageController,
                           mapNavController,
                           profileNavController
                          ]
        
        // modify tabBarItems insets
        guard let items = tabBar.items else { return }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func checkLoggedInUserStatus() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }
            return
        }

    }
    
    private func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
    }
}
