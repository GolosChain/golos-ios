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
    let memoKey: String?
    let ownerKey: String?
    let activeKey: String?
    let postingKey: String?
    let voicePower: String
    var isAuthorized: Bool = false

    
    // MARK: - Class Initialization
    init(fromUser user: User) {
        self.id                 =   user.id
        self.name               =   user.name
        self.postCount          =   user.postCount
        self.memoKey            =   user.memoKey
        self.ownerKey           =   user.owner?.key_auths?.first?.first
        self.activeKey          =   user.active?.key_auths?.first?.first
        self.postingKey         =   user.posting?.key_auths?.first?.first
        self.voicePower         =   user.voicePower.introduced()
        
        if let metaData = user.json_metadata {
            self.parse(metaData: metaData)
        }
    }
    
    
    // MARK: - Custom Functions
    private mutating func parse(metaData: String) {
        if  let data    =   metaData.data(using: .utf8),
            let json    =   try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let profile =   json?["profile"] as? [String: Any] {
            self.about          =   profile["about"] as? String
            self.pictureURL     =   profile["profile_image"] as? String
            self.coverImageURL  =   profile["cover_image"] as? String
        }
    }
}
