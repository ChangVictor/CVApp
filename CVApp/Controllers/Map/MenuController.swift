//
//  MenuController.swift
//  CVApp
//
//  Created by Victor Chang on 10/11/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import UIKit

class MenuController: UITableViewController {
    
    let darkCoverView = DarkCoverView()
    
    
  
    var placesDelegate: PlacesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationController?.isNavigationBarHidden = true
        
        let birthPlace = Place(placeName: "Arica", latitude: -18.478518, longitude: -70.3210596)
        let codingSchool = Place(placeName: "Digital House", latitude: -34.54881224693877, longitude: -58.44375559591837)
        let universityPlace = Place(placeName: "Universidad del CEMA", latitude: -34.598595, longitude: -58.372364)
        let homePlace = Place(placeName: "Home", latitude: -34.610668, longitude: -58.433800)
        
       
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "VictorMemoji630x630").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
    }
    
    let menuItems = [
        MenuItem(icon: #imageLiteral(resourceName: "profile"), title: "My birth place!"),
        MenuItem(icon: #imageLiteral(resourceName: "lists"), title: "Where I live?"),
        MenuItem(icon: #imageLiteral(resourceName: "bookmark"), title: "University"),
        MenuItem(icon: #imageLiteral(resourceName: "moments"), title: "Coding School")
    ]
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeaderView = MenuHeader()
        
        return customHeaderView
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuItemCell(style: .default, reuseIdentifier: "cellId")
        let menuItem = menuItems[indexPath.row]
        cell.iconImageView.image = menuItem.icon
        cell.titleLabel.text = menuItem.title
        return cell
    }
    
}

extension MenuController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placesDelegate?.selectPlace(indexPath: indexPath.row)
        
    }
}

struct MenuItem {
    let icon: UIImage
    let title: String
}
