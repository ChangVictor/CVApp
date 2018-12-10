//
//  PlaceDetailView.swift
//  CVApp
//
//  Created by Victor Chang on 01/12/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit



class PlaceDetailView: UIView {
    
    var place: Place? {
        didSet {
            placeTitle.text = place?.name
            placeDescription.text = place?.description
        }
    }
    @IBOutlet weak var miniPlaceImageView: UIImageView!
    @IBOutlet weak var miniPlaceView: UIView!
    @IBOutlet weak var expandeedStakView: UIStackView!
    @IBOutlet weak var placeButton: UIButton!
    @IBAction func handleDismiss(_ sender: Any) {
        // should create a protocol to call minimizePlaceDetails()
        expandableDelegate?.minimizeTopConstraint()
        print("dismissButton pressed")
        miniPlaceView.isUserInteractionEnabled = true
    }
    
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeDescription: UILabel!
    @IBOutlet weak var placeImageView: UIImageView!

    var expandableDelegate: ExpandableDelegate?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 22
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapExpand)))
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
        
    }
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        print("Panning")
        if gesture.state == .began {
            print("Began")
        } else if gesture.state == .changed {
            print("Changed")
            let translation = gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
//            print(translation.y)
            self.miniPlaceView.alpha = 1 + translation.y / 200
            self.expandeedStakView.alpha = -translation.y / 200
            
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = .identity
                self.miniPlaceView.alpha = 1
                self.expandeedStakView.alpha = 0
 
            }, completion: nil)
        }
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
