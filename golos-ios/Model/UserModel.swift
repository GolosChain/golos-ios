//
//  UserModel.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct UserModel {
    let userId: Int
    let name: String
    let about: String?
    let postCount: Int
    let pictureUrl: String?
    let coverImageUrl: String?
    
    
    init?(userDictionary: [String: Any]) {
        guard let id = userDictionary["id"] as? Int,
            let name = userDictionary["name"] as? String
            else {
                return nil
        }
        
        self.userId = id
        self.name = name
        
        self.postCount = userDictionary["post_count"] as? Int ?? 0
        
        var about: String?
        var pictureUrl: String?
        var coverImageUrl: String?
        
        if let metadataString = userDictionary["json_metadata"] as? String,
            let data = metadataString.data(using: .utf8),
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
        let profile = json?["profile"] as? [String: Any] {
            about = profile["about"] as? String
            pictureUrl = profile["profile_image"] as? String
            coverImageUrl = profile["cover_image"] as? String
        } else {
            about = ""
        }
        
        self.about = about
        self.pictureUrl = pictureUrl
        self.coverImageUrl = coverImageUrl
    }
    
}
