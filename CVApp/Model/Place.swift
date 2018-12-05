//
//  File.swift
//  CVApp
//
//  Created by Victor Chang on 05/12/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation
import GoogleMaps

struct Place {
    var name: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var snippet: String?
    var description: String?
    
    init(placeName: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        self.name = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
}
