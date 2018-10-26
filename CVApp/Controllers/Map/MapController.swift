//
//  MapController.swift
//  CVApp
//
//  Created by Victor Chang on 13/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit
import GoogleMaps

class MapController: UIViewController {
    
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
        searchBar.isTranslucent = false
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 250, green: 250, blue: 250)
        return searchBar
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = navigationController?.navigationBar
        navigationController?.navigationBar.addSubview(searchBar)
        searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        view.backgroundColor = .white
        
        loadView()
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
