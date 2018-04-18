//
//  ProfileViewModel.swift
//  Golos
//
//  Created by Grigory on 02/03/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct ProfileViewModel {
    let name: String
    let pictureUrl: String?
    let backgroundImageUrl: String?
    let starsAmount: String = "80"
    let rank: String = "Дельфин"
    let information: String
    let postsCount: String
}

extension ProfileViewModel {
    init(userModel: DisplayedUser) {
        self.name = userModel.name
        self.pictureUrl = userModel.pictureURL
        self.backgroundImageUrl = userModel.coverImageURL
        self.information = userModel.about ?? ""
        self.postsCount = "\(userModel.postCount)"
    }
}
