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
        
//         map center marker -34.610668, -58.433800
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -34.610668, longitude: -58.433800)
        marker.title = "Victor's Home Radius"
        marker.snippet = "I've lived in Caballito for about 20."
        marker.opacity = 0.6

        marker.map = mapView
        let circleCenter = CLLocationCoordinate2D(latitude: -34.610668, longitude: -58.433800)
        let circle = GMSCircle(position: circleCenter, radius: 250)
        circle.fillColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.2)
        circle.strokeColor = UIColor(red: 74/255, green: 137/255, blue: 243/255, alpha: 0.75)
        circle.map = mapView
    }

}
