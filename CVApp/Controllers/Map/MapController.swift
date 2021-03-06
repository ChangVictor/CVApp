//
//  MapController.swift
//  CVApp
//
//  Created by Victor Chang on 13/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol ExpandableDelegate {
    func minimizeTopConstraint()
    func expandTopConstraint()
}

protocol PlacesDelegate {
    func selectPlace(indexPath: Int?)
//    func selectPlace(marker: GMSMarker)
}

class MapController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    var initialTopAnchorConstraint: NSLayoutConstraint?
    var expandedTopAnchorConstraint: NSLayoutConstraint?
    var minimizedTopAnchorConstraint: NSLayoutConstraint?
    var bottomAnchorConstraint: NSLayoutConstraint?
    var hiddenTopAnchorConstraint: NSLayoutConstraint?

    var locationManager = CLLocationManager()
    var placesClient: GMSPlacesClient!
//    var place: Place
    var places = [
                    Place(placeName: "Arica", latitude: -18.478518, longitude: -70.3210596),
                    Place(placeName: "Digital House", latitude: -34.54881224693877, longitude: -58.44375559591837),
                    Place(placeName: "Universidad del CEMA", latitude: -34.598595, longitude: -58.372364),
                    Place(placeName: "Home", latitude: -34.610668, longitude: -58.433800),
                    Place(placeName: "International Parts Service S.A.", latitude: -34.588219, longitude: -58.465579)
                ]
    
    let placeDetailView = PlaceDetailView.initFromNib()
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        menuController.placesDelegate = self
        placeDetailView.expandableDelegate = self
        
        setupLocationManager()
        
        setupBarButtons()
        let navBar = navigationController?.navigationBar
//        navigationController?.navigationBar.addSubview(searchBar)
//        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor , bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 55, paddingBottom: 0, paddingRight: 65, width: 0, height: 0)
        
        view.backgroundColor = .white

        loadView()
        setupDarkCoverViewGesture()
        setupDarkCoverView()

    }

    // MARK:- Fileprivate
    
    fileprivate func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        placesClient = GMSPlacesClient.shared()
    }
    let darkCoverView = UIView()
    var darkCoverLeftConstraint: NSLayoutConstraint!
    let menuView = UIView()
    
    fileprivate func hidePlaceDetails() {
        expandedTopAnchorConstraint?.isActive = false
        minimizedTopAnchorConstraint?.isActive = false
        initialTopAnchorConstraint?.isActive = true

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        })
        
        let mainTabBar = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBar?.tabBar.transform = .identity

    }
    
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
    fileprivate func setupDarkCoverViewGesture() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        darkCoverView.addGestureRecognizer(panGesture)
        panGesture.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss))
        darkCoverView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func setupBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "grid").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleOpenSlideView))
//        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMapViewReset))
    }

    fileprivate func performAnimations(transform: CGAffineTransform) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseOut, animations: {
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
    @objc fileprivate func handleMapViewReset() {
        triggerMapTransition(withDuration: 1, latitude: -34.608795, longitude: -58.434670, zoom: 12, bearing: 0, viewAngle: 0)
        hidePlaceDetails()
    }
    @objc fileprivate func handleOpenSlideView() {
        isMenuOpened = true
        print("sideView triggered")
        setupMenuView()
        hidePlaceDetails()
        performAnimations(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleHide() {
        isMenuOpened = false
        performAnimations(transform: .identity)
    }

    @objc fileprivate func handleTapDismiss() {
        handleHide()
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
        
        for place in places {
            markPlace(place: place)
        }

        let circleCenter = CLLocationCoordinate2D(latitude: -34.610668, longitude: -58.433800)
        let circle = GMSCircle(position: circleCenter, radius: 250)
        circle.fillColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.2)
        circle.strokeColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.75)
        circle.map = mapView
    }
    
    @discardableResult
    private func markPlace(place: Place) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = place.name
        marker.position = CLLocationCoordinate2DMake(place.latitude, place.longitude)
        marker.snippet = place.snippet
        marker.opacity = 0.9
        marker.map = mapView
        return marker
    }
    
    private func placeMarker(title: String, snippet: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> GMSMarker {
        let marker = GMSMarker()
        marker.title = title
        marker.opacity = 0.9
        marker.snippet = snippet
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        return marker
    }
    
    func addBottomSheetView() {
        let bottomSheetController = BottomSheetController()
        self.addChild(bottomSheetController)
        self.view.addSubview(bottomSheetController.view)
        bottomSheetController.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        bottomSheetController.view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)
    }
    
    func minimizePlaceDetails() {
        initialTopAnchorConstraint?.isActive = false
        expandedTopAnchorConstraint?.isActive = false
        bottomAnchorConstraint?.constant = view.frame.height / 2
        minimizedTopAnchorConstraint?.isActive = true
        let mainTabBar = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
//        mainTabBar?.tabBar.transform = .identity
        mainTabBar?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.placeDetailView.layoutIfNeeded()
            self.placeDetailView.expandeedStakView.alpha = 0
            self.placeDetailView.miniPlaceView.alpha = 1
        })
    }

    @objc func  expandPlaceDetails() {
        let mainTabBar = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBar?.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        minimizedTopAnchorConstraint?.isActive = false
        initialTopAnchorConstraint?.isActive = false
        expandedTopAnchorConstraint?.isActive = true
        bottomAnchorConstraint?.constant = view.frame.height /* tweak this */

        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.placeDetailView.layoutIfNeeded()
            self.placeDetailView.expandeedStakView.alpha = 1
            self.placeDetailView.miniPlaceView.alpha = 0

        })
    }
}

extension MapController: ExpandableDelegate {
    func expandTopConstraint() {
        expandPlaceDetails()
    }
    func minimizeTopConstraint() {
        minimizePlaceDetails()
    }
}

extension MapController: PlacesDelegate {
    
    func selectPlace(indexPath: Int?) {
        
        guard let indexPath = indexPath else { return }
        
        switch indexPath {
        case 0:

            triggerMapTransition(withDuration: 3, latitude: -19.209054, longitude: -70.272129, zoom: 8, bearing: 0, viewAngle: 0)
            placeDetailView.placeTitle.text = "Arica, Chile."
            placeDetailView.placeDescription.text = "Even though I have Taiwanese ascendance and I grew up in Argentina, I was originally born in  Arica, north of Chile. And moved to Argentina at the age of 3."
            placeDetailView.placeImageView.image = #imageLiteral(resourceName: "Arica")
            
        case 1:
            triggerMapTransition(withDuration: 1.3, latitude: -34.612157, longitude: -58.433159, zoom: 17, bearing: 340, viewAngle: 45)
            placeDetailView.placeTitle.text = "Victor's Home"
            placeDetailView.placeDescription.text = "I've lived in Caballito for over 25 years. A comfortable neightbourhood right in the heart of Buenos Aires. It might have a low profile, but is full of character character, and yet isn’t too far from the action"
            placeDetailView.placeImageView.image = #imageLiteral(resourceName: "homePlace")
        case 2:
            triggerMapTransition(withDuration: 1.2, latitude: -34.601639, longitude: -58.372542, zoom: 16, bearing: 0, viewAngle: 45)
            
            placeDetailView.placeTitle.text = "Universidad del CEMA"
            placeDetailView.placeDescription.text = "In the year 2010 I started studying at the CEMA University, for a Bachelor's degree in Business Administration."
            placeDetailView.placeImageView.image = #imageLiteral(resourceName: "ucema")

        case 3:
            triggerMapTransition(withDuration: 1.3, latitude: -34.547904, longitude: -58.442442, zoom: 16, bearing: 235, viewAngle: 45)
            placeDetailView.placeTitle.text = "Digital House Coding School"
            placeDetailView.placeDescription.text = "I started my coding journey about a year ago, first learning the basics of HTML, CSS, PHP and Javascript and doing some Web Development, only until I found myself fulfulling the curiousness that was growing on me about the Swift language and iOS development."
            placeDetailView.placeImageView.image = #imageLiteral(resourceName: "digitalHouse")
        default:
            triggerMapTransition(withDuration: 1.3, latitude: -34.591193, longitude: -58.466100, zoom: 16, bearing: 0, viewAngle: 45)
            placeDetailView.placeTitle.text = "International Parts Service S.A."
            placeDetailView.placeDescription.text = "Automotive parts SMB"
            placeDetailView.placeImageView.image = #imageLiteral(resourceName: "digitalHouse")
        }
        
        handleHide()
        setupPlaceDetailView()
        placeDetailView.miniPlaceTitle.text = placeDetailView.placeTitle.text
        placeDetailView.miniPlaceImageView.image = placeDetailView.placeImageView.image
        placeDetailView.panGesture.isEnabled = false
        perform(#selector(expandPlaceDetails), with: nil, afterDelay: 1)
        
    }

    func setupPlaceDetailView() {
        guard let mainWindow = UIApplication.shared.keyWindow else { return }
        mainWindow.addSubview(placeDetailView)
        placeDetailView.translatesAutoresizingMaskIntoConstraints = false
        initialTopAnchorConstraint = placeDetailView.topAnchor.constraint(equalTo: mainWindow.topAnchor, constant: view.frame.height)
        initialTopAnchorConstraint?.isActive = true
        expandedTopAnchorConstraint = placeDetailView.topAnchor.constraint(equalTo: mainWindow.topAnchor, constant: view.frame.height / 2)
        expandedTopAnchorConstraint?.isActive = false
        minimizedTopAnchorConstraint = placeDetailView.topAnchor.constraint(equalTo: mainWindow.bottomAnchor, constant: -85)
        minimizedTopAnchorConstraint?.isActive = false
        bottomAnchorConstraint = placeDetailView.bottomAnchor.constraint(equalTo: mainWindow.bottomAnchor, constant: view.frame.height )
        bottomAnchorConstraint?.isActive = true
        placeDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        placeDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func triggerMapTransition(withDuration: Double, latitude: CLLocationDegrees, longitude: CLLocationDegrees, zoom: Float, bearing: CLLocationDirection, viewAngle: Double) {
        CATransaction.begin()
        CATransaction.setValue(withDuration, forKey: kCATransactionAnimationDuration)
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom, bearing: bearing, viewingAngle: viewAngle)
        self.mapView.animate(to: camera)
        CATransaction.commit()
    }
}

