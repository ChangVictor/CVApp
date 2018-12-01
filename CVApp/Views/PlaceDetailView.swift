//
//  PlaceDetailView.swift
//  CVApp
//
//  Created by Victor Chang on 01/12/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class PlaceDetailView: UIView {
    
    @IBAction func handleDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!

}
