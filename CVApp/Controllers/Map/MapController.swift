//
//  MapController.swift
//  CVApp
//
//  Created by Victor Chang on 13/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController, UIGestureRecognizerDelegate {
    
    fileprivate let menuWidth: CGFloat = 300
    fileprivate var isMenuOpened = false
    var menuController = MenuController()
    fileprivate let velocityOpenThreshold: CGFloat = 500
    
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Victor's Places..."
        searchBar.barTintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        return searchBar
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor , bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        view.backgroundColor = .white
        
        loadView()
        setupPangeGesture()
        setupDarkCoverView()
    }
    
    // MARK:- Fileprivate
    let darkCoverView = UIView()
    
    fileprivate func setupDarkCoverView() {
        darkCoverView.alpha = 0
        darkCoverView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        darkCoverView.isUserInteractionEnabled = false
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(darkCoverView)
        darkCoverView.frame = mainWindow?.frame ?? .zero
    }
    fileprivate func setupPangeGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        darkCoverView.addGestureRecognizer(panGesture)
    }
    
    fileprivate func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOpenSlideView))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    fileprivate func setupMenuController() {
        menuController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(menuController.view)
        addChild(menuController)
    }
    
    fileprivate func performAnimations(transfrom: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuController.view.transform = transfrom
            self.darkCoverView.transform = transfrom
        })
    }
    
    @objc fileprivate func handleOpenSlideView() {
        isMenuOpened = true
        print("sideView triggered")
        setupMenuController()
        performAnimations(transfrom: CGAffineTransform(translationX: self.menuWidth, y: 0))
        self.darkCoverView.alpha = 0.6
        self.darkCoverView.isUserInteractionEnabled = true
    }
    
    @objc func handleHide() {
        isMenuOpened = false
        performAnimations(transfrom: .identity)
        self.darkCoverView.isUserInteractionEnabled = false
        self.darkCoverView.alpha = 0
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        
        if gesture.state == .changed {
            var x = translation.x
            
            if isMenuOpened {
                
                x += menuWidth
            }
            
            x = min(menuWidth, x)
            x = max(0, x)
            
            let transform = CGAffineTransform(translationX: x, y: 0)
            menuController.view.transform = transform
            darkCoverView.transform = transform
            
//            let alpha = x / menuWidth
//            darkCoverView.alpha = alpha
            
        } else if gesture.state == .ended {
            handleEnded(gesture: gesture)
        }
    }
    
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        let velocity = gesture.velocity(in: view)
        
        if isMenuOpened {
            if abs(velocity.x) > velocityOpenThreshold {
                handleHide()
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                handleOpenSlideView()
            } else {
                handleHide()
            }
        } else {
            if velocity.x > velocityOpenThreshold {
                handleOpenSlideView()
                return
            }
            if translation.x < menuWidth / 2 {
            handleHide()
        } else {
            handleOpenSlideView()
            }
        }
    }
    
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: -34.608795, longitude: -58.434670, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.settings.myLocationButton = true
        view = mapView
        
//         map center marker -34.610668, -58.433800
        let homeMarker = GMSMarker()
        homeMarker.position = CLLocationCoordinate2D(latitude: -34.610668, longitude: -58.433800)
        homeMarker.title = "Victor's Home Location"
        homeMarker.snippet = "I've been living in Caballito for more than 20."
        homeMarker.opacity = 0.6
        homeMarker.map = mapView
        
        let gymMarker = GMSMarker()
        gymMarker.position = CLLocationCoordinate2D(latitude: -34.612626, longitude: -58.432023)
        gymMarker.title = "Tuluka Crossfit"
        gymMarker.snippet = "This is where I usually work out"
        gymMarker.opacity = 0.6
        gymMarker.layer.cornerRadius = 5
        gymMarker.map = mapView
        
//        let universityMarker = GMSMarker()
//        universityMarker.position = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: CLLocationDegrees)
//        universityMarker.title = "Universidad del CEMA"
//        universityMarker.snippet = "BA degree in Business Administration"
//        universityMarker.map = mapView
        
        
        let circleCenter = CLLocationCoordinate2D(latitude: -34.610668, longitude: -58.433800)
        let circle = GMSCircle(position: circleCenter, radius: 250)
        circle.fillColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.2)
        circle.strokeColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.75)
        circle.map = mapView
        
    }
    
    // getTappedLocation
//    func mapView(mapViewUIView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
//        marker.position.latitude = coordinate.latitude
//        marker.position.longitude = coordinate.longitude
//
//        println(marker.position.latitude)
//        let ULlocation = marker.position.latitude
//        let ULlgocation = marker.position.longitude
//
//    }
   
}

extension MapController: UISearchBarDelegate {
    
}
