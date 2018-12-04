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
        // should create a protocol to call minimizePlaceDetails()
        expandableDelegate?.minimizeTopConstraint()
    }
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!

    var expandableDelegate: ExpandableDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapExpand)))
        self.layer.cornerRadius = 22
    }
    
    @objc func handleTapExpand() {
        print("tapping to maximize")
        // calling the same map protocol in order to expand the place detail view
        expandableDelegate?.expandTopConstraint()
    }
    
    static func initFromNib() -> PlaceDetailView {
        return Bundle.main.loadNibNamed("PlaceDetailView", owner: self, options: nil)?.first as! PlaceDetailView
        
    }
    
    deinit {
        print("PlaceDetailView memory being reclaimed...")
    }
    
}
