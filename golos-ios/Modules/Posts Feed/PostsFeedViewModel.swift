//
//  PostsFeedViewModel.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

struct PostsFeedViewModel {
    let authorName: String
    let authorAvatarUrl: String?
    let articleTitle: String
    let reblogAuthorName: String?
    let theme: String
    let articleBody: String
    let postDescription: String
    let imagePictureUrl: String?
    let upvoteAmount: String
    let commentsAmount: String
    let didUpvote: Bool
    let didComment: Bool
}
