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
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        loadView()
    }
    
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: -34.608795, longitude: -58.434670, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
        view = mapView
        
        // map center marker
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: -34.608795, longitude: -58.434670)
//        marker.title = "Home"
//        marker.snippet = "I've lived in Caballito for about 20 years."
//        marker.opacity = 0.6
//
//        marker.map = mapView
        let circleCenter = CLLocationCoordinate2D(latitude: -34.609005, longitude: -58.434628)
        let circle = GMSCircle(position: circleCenter, radius: 250)
        circle.fillColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.2)
        circle.strokeColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.75)
        circle.title = "Victor's Home Radius"
        circle.map = mapView
    }

}
