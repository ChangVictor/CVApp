//
//  Post.swift
//  CVApp
//
//  Created by Victor Chang on 11/10/2018.
//  Copyright © 2018 Victor Chang. All rights reserved.
//

import Foundation

struct Post {
    var id: String?
    
    let user: User
    let imageUrl: String?
    let message: String
    let creationDate: Date
    
    var hasLiked = false
    
//    init(user: User, dictionary: [String: Any]) {
//        self.user = user
//        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
//        self.message = dictionary["message"] as? String ?? ""
//        
//        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
//        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
//    }
}
