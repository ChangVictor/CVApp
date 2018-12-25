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
            // not working
            placeTitle.text = place?.name
            placeDescription.text = place?.description
            miniPlaceTitle.text = placeTitle.text
            miniPlaceImageView.image = placeImageView.image
            
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
        panGesture.isEnabled = true
        
    }
    
    @IBOutlet weak var miniPlaceTitle: UILabel!
    @IBOutlet weak var placeTitle: UILabel!
    @IBOutlet weak var placeDescription: UITextView!
    @IBOutlet weak var placeImageView: UIImageView! {
        didSet {
            placeImageView.layer.cornerRadius = 10
        }
    }

    var expandableDelegate: ExpandableDelegate?
    var panGesture: UIPanGestureRecognizer!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 22
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapExpand)))
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(panGesture)
    }
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
        } else if gesture.state == .ended {
            handlePanEnded(gesture: gesture)
        }
    }
    
    fileprivate func handlePanChanged(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlaceView.alpha = 1 + translation.y / 200
        self.expandeedStakView.alpha = -translation.y / 200
    }
    
    fileprivate func handlePanEnded(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -500 {
                self.expandableDelegate?.expandTopConstraint()
                gesture.isEnabled = false
            } else {
                self.miniPlaceView.alpha = 1
                self.expandeedStakView.alpha = 0
            }
            
        }, completion: nil)
    }
    @objc func handleTapExpand() {
        print("tapping to maximize")
        // calling the same map protocol in order to expand the place detail view
        expandableDelegate?.expandTopConstraint()
        panGesture.isEnabled = false
        
    }
    
    static func initFromNib() -> PlaceDetailView {
        return Bundle.main.loadNibNamed("PlaceDetailView", owner: self, options: nil)?.first as! PlaceDetailView
    }
    
    deinit {
        print("PlaceDetailView memory being reclaimed...")
    }
    
}
