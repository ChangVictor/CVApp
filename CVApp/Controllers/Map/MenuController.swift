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
        MenuItem(icon: #imageLiteral(resourceName: "profile"), title: "Where I Live?"),
        MenuItem(icon: #imageLiteral(resourceName: "lists"), title: "Education"),
        MenuItem(icon: #imageLiteral(resourceName: "bookmark"), title: "Some other place"),
        MenuItem(icon: #imageLiteral(resourceName: "moments"), title: "Another place")
    ]
    
    var placesDelegate: PlacesDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationController?.isNavigationBarHidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "VictorMemoji630x630").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: nil)
        
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customHeaderView = MenuHeader()
        return customHeaderView
    }
    
//        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//            return 120
//        }
    
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
        print("Selected menu Item: ", indexPath.row)

        placesDelegate?.selectPlace(indexPath: indexPath.row)
    }
}

struct MenuItem {
    let icon: UIImage
    let title: String
}
