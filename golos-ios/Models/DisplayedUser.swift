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
    let postsCount: Int64
    let subscribersCount: Int64
    let subscribtionsCount: Int64
    var pictureURL: String?
    var coverImageURL: String?
    let memoKey: String?
    let ownerKey: String?
    let activeKey: String?
    let postingKey: String?
    let voicePower: String
    let voicePowerImageName: String
    var isAuthorized: Bool = false
    let selectedTags: [String]?

    
    // MARK: - Class Initialization
    init(fromUser user: User) {
        self.id                     =   user.id
        self.name                   =   user.name
        self.postsCount             =   user.postsCount
        self.subscribersCount       =   user.postsCount
        self.subscribtionsCount     =   user.postsCount
        self.memoKey                =   user.memoKey
        self.ownerKey               =   user.owner?.key_auths?.first?.first
        self.activeKey              =   user.active?.key_auths?.first?.first
        self.postingKey             =   user.posting?.key_auths?.first?.first
        self.voicePower             =   user.voicePower.introduced().localized()
        self.voicePowerImageName    =   String(format: "icon-voice-power-%@", user.voicePower.introduced().lowercased())
        self.about                  =   user.about
        self.pictureURL             =   user.profileImageURL
        self.coverImageURL          =   user.coverImageURL
        self.selectedTags           =   user.selectTags
    }
}
