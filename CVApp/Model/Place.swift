//
//  File.swift
//  CVApp
//
//  Created by Victor Chang on 05/12/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation
import GoogleMaps

class Place {
    var placeName: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init(placeName: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
}
