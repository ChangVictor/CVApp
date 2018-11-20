//
//  MenuController.swift
//  CVApp
//
//  Created by Victor Chang on 10/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    let menuItems = [
        MenuItem(icon: #imageLiteral(resourceName: "location_selected"), title: "Places"),
        MenuItem(icon: #imageLiteral(resourceName: "ribbon"), title: "Bookmarks"),
        MenuItem(icon: #imageLiteral(resourceName: "send2"), title: "Messages"),
        MenuItem(icon: #imageLiteral(resourceName: "profile_selected"), title: "Victor's")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cellId")
        
        return cell
    }
    
}

struct MenuItem {
    let icon: UIImage
    let title: String
}

extension MenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let slidingController = SliderController()
    }
}

