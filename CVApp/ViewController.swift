//
//  ViewController.swift
//  CVApp
//
//  Created by Victor Chang on 09/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    @objc func handlePlusPhoto() {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

