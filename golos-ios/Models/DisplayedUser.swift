//
//  UserModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

struct DisplayedUser {
    // MARK: - Properties
    let id: Int64
    let name: String
    var about: String?
    let postCount: Int64
    var pictureURL: String?
    var coverImageURL: String?
    
    
    // MARK: - Class Initialization
    init(fromResponseAPIUser user: ResponseAPIUser) {
        self.id                 =   user.id
        self.name               =   user.name
        self.postCount          =   user.post_count
        
        if  let metaData        =   user.json_metadata,
            let data            =   metaData.data(using: .utf8),
            let json            =   try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let profile         =   json?["profile"] as? [String: Any] {
            self.about          =   profile["about"] as? String
            self.pictureURL     =   profile["profile_image"] as? String
            self.coverImageURL  =   profile["cover_image"] as? String
        }
    }
}
