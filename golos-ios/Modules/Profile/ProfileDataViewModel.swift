//
//  ProfileDataViewModel.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct ProfileDataViewModel {
    let name: String
    let avatarUrlString: String?
    let starsString: String
    let rankString: String
    let information: String
    let postsAmountString: String
    let subscribersAmountString: String
    let subscriptionsAmountString: String
}

extension ProfileDataViewModel {
    init() {
        name = ""
        avatarUrlString = nil
        starsString = "0"
        rankString = ""
        information = ""
        postsAmountString = "0"
        subscribersAmountString = "0"
        subscriptionsAmountString = ""
    }
}
