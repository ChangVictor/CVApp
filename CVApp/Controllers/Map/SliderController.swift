//
//  SliderController.swift
//  CVApp
//
//  Created by Victor Chang on 20/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class RightContainerView: UIView {}
class MenuContainerView: UIView {}
class DarkCoverView: UIView {}

class SliderController: UIViewController {
    
    var menuController = MenuController()
    var rightViewController: UIViewController = UINavigationController(rootViewController: MapController())
    
    let redView: RightContainerView = {
        let view = RightContainerView()
        return view
    }()
    
    let blueView: MenuContainerView = {
        let view = MenuContainerView()
        return view
    }()
    
    let darkCoverView: DarkCoverView = {
        let view = DarkCoverView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        view.alpha = 0
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        
        setupView()
    
    }
    
    var redViewLeadingConstraint: NSLayoutConstraint!
    var redViewTrailingConstraint: NSLayoutConstraint!
    fileprivate let menuWidth: CGFloat = 300
    fileprivate let velocityOpenThreshold: CGFloat = 500
    fileprivate var isMenuOpened = false
    
    fileprivate func setupView() {

        view.addSubview(redView)
        view.addSubview(blueView)
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blueView.topAnchor.constraint(equalTo: view.topAnchor),
            blueView.trailingAnchor.constraint(equalTo: redView.leadingAnchor),
            blueView.widthAnchor.constraint(equalToConstant: menuWidth),
            blueView.bottomAnchor.constraint(equalTo: redView.bottomAnchor)
            ])
        
        
        redViewLeadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        redViewLeadingConstraint.isActive = true
        
        redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        redViewTrailingConstraint = redView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        redViewTrailingConstraint.isActive = true
        
        
        setupViewControllers()
        
    }
    
    fileprivate func setupViewControllers() {
        let menuController = MenuController()
        
        let homeView = rightViewController.view!
        let menuView = menuController.view!
        
        redView.addSubview(homeView)
        redView.addSubview(darkCoverView)
        blueView.addSubview(menuView)
        
        homeView.anchor(top: redView.topAnchor, left: redView.leftAnchor, bottom: redView.bottomAnchor, right: redView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        menuView.anchor(top: blueView.topAnchor, left: blueView.leftAnchor, bottom: blueView.bottomAnchor, right: blueView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        darkCoverView.anchor(top: redView.topAnchor, left: redView.leftAnchor, bottom: redView.bottomAnchor, right: redView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        addChild(rightViewController)
        addChild(menuController)
    }

    
}
