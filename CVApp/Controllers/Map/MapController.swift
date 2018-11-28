//
//  MapController.swift
//  CVApp
//
//  Created by Victor Chang on 13/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import GoogleMaps

protocol PlacesDelegate {
    func selectPlace(indexPath: Int?)
//    func selectPlace(marker: GMSMarker)
}

class MapController: UIViewController, UIGestureRecognizerDelegate {
    var menuController = MenuController()
    fileprivate let menuWidth: CGFloat = 300
    fileprivate var isMenuOpened = false
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
        menuController.placesDelegate = self
        
        setupBarButtons()
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor , bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 50, paddingBottom: 0, paddingRight: 20, width: 0, height: 0)
        
        view.backgroundColor = .white

        loadView()
        setupPangeGesture()
        setupDarkCoverView()
//        setupViewControllers()
    }
    
    // MARK:- Fileprivate
    let darkCoverView = UIView()
    var darkCoverLeftConstraint: NSLayoutConstraint!
    
    let menuView = UIView()
    
    fileprivate func setupViewControllers() {
        menuView.addSubview(menuController.view)

        menuController.view.anchor(top: menuView.topAnchor, left: menuView.leftAnchor, bottom: menuView.bottomAnchor, right: menuView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        addChild(menuController)
    }
    
    fileprivate func setupDarkCoverView() {
        darkCoverView.alpha = 0
        darkCoverView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        darkCoverView.isUserInteractionEnabled = false
        guard let mainWindow = UIApplication.shared.keyWindow else { return }
        mainWindow.addSubview(darkCoverView)
        darkCoverView.frame = mainWindow.frame
        darkCoverView.anchor(top: mainWindow.topAnchor, left: nil, bottom: mainWindow.bottomAnchor, right: mainWindow.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        self.darkCoverLeftConstraint = darkCoverView.leftAnchor.constraint(equalTo: mainWindow.leftAnchor, constant: 0)
        darkCoverLeftConstraint.isActive = true
        
    }
    fileprivate func setupMenuView() {
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(menuController.view)

//        addChild(menuController)
        menuController.view.anchor(top: mainWindow?.topAnchor, left: nil, bottom: mainWindow?.bottomAnchor, right: darkCoverView.leftAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.menuWidth, height: 0)
    }
    
    fileprivate func setupMenuController() {
        menuController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
        let mainWindow = UIApplication.shared.keyWindow
        mainWindow?.addSubview(menuController.view)
        addChild(menuController)
    }
    fileprivate func setupPangeGesture() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        darkCoverView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    fileprivate func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOpenSlideView))
        navigationItem.rightBarButtonItem?.tintColor = .white
    }

    fileprivate func performAnimations(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuController.view.transform = transform
            self.darkCoverView.transform = transform
            if transform == .identity {
                self.darkCoverView.alpha = 0
                self.darkCoverView.isUserInteractionEnabled = false
            } else {
                self.darkCoverView.alpha = 0.6
                self.darkCoverView.isUserInteractionEnabled = true
            }
            self.view.layoutIfNeeded()
        })
    }
    
    @objc fileprivate func handleOpenSlideView() {
        isMenuOpened = true
        print("sideView triggered")
        setupMenuView()
        performAnimations(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleHide() {
        isMenuOpened = false
        performAnimations(transform: .identity)
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
    
//    let camera = GMSCameraPosition.camera(withLatitude: -34.608795, longitude: -58.434670, zoom: 12.0)
    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: -34.608795, longitude: -58.434670, zoom: 12.0))
    
    override func loadView() {
        
        
        
        self.mapView.settings.myLocationButton = true
        view = mapView
        
        let homeMarker = placeMarker(title: "Victor's home", snippet: "", latitude: -34.610668, longitude: -58.433800)
        homeMarker.map = mapView
        
        let gymMarker = placeMarker(title: "Tuluka Crossfit", snippet: "I usually twice or thrice a week", latitude: -34.612626, longitude: -58.432023)
        gymMarker.map = mapView
        
        let universityMarker = placeMarker(title: "Universidad del Cema", snippet: "BA degree in Business Administration", latitude: -34.5986073, longitude: -58.3758671)
        universityMarker.map = mapView
        
        //
//        let bounds = GMSCoordinateBounds(coordinate: homeMarker.position, coordinate: universityMarker.position)
//        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
//        mapView.camera = camera
        
        let circleCenter = CLLocationCoordinate2D(latitude: -34.610668, longitude: -58.433800)
        let circle = GMSCircle(position: circleCenter, radius: 250)
        circle.fillColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.2)
        circle.strokeColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.75)
        circle.map = mapView
        
        let bornPlace = placeMarker(title: "Arica", snippet: "Victor's born place", latitude: -18.478518, longitude: -70.3210596)
        bornPlace.map = mapView
        
        let digitalHouseMarker = placeMarker(title: "Digital House", snippet: "Coding School", latitude: -34.54881224693877, longitude: -58.44375559591837)
        digitalHouseMarker.map = mapView
        
    }
    
    private func placeMarker(title: String, snippet: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> GMSMarker {
        
        let marker = GMSMarker()
        marker.title = title
        marker.opacity = 0.9
        marker.snippet = snippet
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        return marker
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

extension MapController: PlacesDelegate {
    func selectPlace(indexPath: Int?) {
        
        /* handle camera position & CLLocationCoordiante2DMake:
         option 1: set hardcoded markers and use
         
         mapView.animate(toLocation: CLLocationCoordinate2D(latitude: -33.868, longitude: 151.208))
         
         to animate to a location.
         
         - consider usin bearing to add motion effect
         mapView.animate(toBearing: 0)

         - Set the camera such that every marker appear on the same view:
         let vancouver = CLLocationCoordinate2D(latitude: 49.26, longitude: -123.11)
         let calgary = CLLocationCoordinate2D(latitude: 51.05,longitude: -114.05)
         let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
         let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
         mapView.camera = camera
        */
        guard let indexPath = indexPath else { return }
        
        switch indexPath {
        case 0:
            
            let camera = GMSCameraPosition.camera(withLatitude: -34.610668,
                                                 longitude: -58.433800,
                                                 zoom: 10,
                                                 bearing: 270,
                                                 viewingAngle: 45)
            
            self.mapView.camera = camera
            self.mapView.animate(to: camera)
            self.mapView.animate(toZoom: 10.5)
            self.mapView.animate(toZoom: 11)
            self.mapView.animate(toZoom: 11.5)
            self.mapView.animate(toZoom: 12)
            self.mapView.animate(toZoom: 13)
            self.mapView.animate(toZoom: 14)
            self.mapView.animate(toZoom: 15)
            self.mapView.animate(toZoom: 16)


            
        case 1:
            let camera = GMSCameraPosition.camera(withLatitude: -34.54881224693877,
                                                  longitude: -58.44375559591837,
                                                  zoom: 10,
                                                  bearing: 270,
                                                  viewingAngle: 45)
            
            self.mapView.camera = camera
            self.mapView.animate(to: camera)
            self.mapView.animate(toZoom: 10.5)
            self.mapView.animate(toZoom: 11)
            self.mapView.animate(toZoom: 11.5)
            self.mapView.animate(toZoom: 12)
            self.mapView.animate(toZoom: 13)
            self.mapView.animate(toZoom: 14)
            self.mapView.animate(toZoom: 15)
            self.mapView.animate(toZoom: 16)


        case 2:
            print("Showing place at \(indexPath)")
        default:
            print("Showing place at \(indexPath)")

        }
        
        handleHide()
        // should hide menu controller and open a bottom sheet view
    }
}
