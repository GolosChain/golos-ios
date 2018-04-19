//
//  FeedTabPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol PostsFeedPresenterProtocol: class {
    func loadNext()
    func loadPostsFeed()

    func getFeedPostsType() -> PostsFeedType
//    func getUser(at index: Int) -> UserModel?
    func setPostsFeedType(_ type: PostsFeedType)
    func getPostsViewModels() -> [PostsFeedViewModel]
    func getPostViewModel(at index: Int) -> PostsFeedViewModel?
    func getPostPermalinkAndAuthorName(at index: Int) -> (permlink: String, authorName: String)
    
//    func loadRepliesForPost(at index: Int)
}

protocol PostsFeedViewProtocol: class {
    func didLoadPosts()
    func didLoadPostsAuthors()
    func didLoadPostReplies(at index: Int)
}

class PostsFeedPresenter: NSObject {
    // MARK: - Properties
    weak var postsFeedView: PostsFeedViewProtocol!
    
    private let batchCount = 10
    private var postsLimit = webSocketLimit
    private var displayedPosts = [DisplayedPost]()
    private var postsItems = [PostsFeedViewModel]()
    private var postsFeedType: PostsFeedType = .new

    private let userManager = UserManager()
    private let replyManager = ReplyManager()
    private let postsFeedManager = PostsFeedManager()
}


// MARK: - PostsFeedPresenterProtocol
extension PostsFeedPresenter: PostsFeedPresenterProtocol {
    func getUser(at index: Int) -> DisplayedUser? {
        Logger.log(message: "Success", event: .severe)
        
        return displayedPosts[index].author
    }
    
    func getPostPermalinkAndAuthorName(at index: Int) -> (permlink: String, authorName: String) {
        Logger.log(message: "Success", event: .severe)

        let displayedPost = displayedPosts[index]
        return (permlink: displayedPost.permlink, authorName: displayedPost.authorName)
    }
    
    func setPostsFeedType(_ type: PostsFeedType) {
        Logger.log(message: "Success", event: .severe)

        self.postsFeedType = type
    }
    
    func getFeedPostsType() -> PostsFeedType {
        Logger.log(message: "Success", event: .severe)

        return self.postsFeedType
    }
    
    /// Load Feed posts
    func loadPostsFeed() {
        Logger.log(message: "Success", event: .severe)

        postsFeedManager.loadPostsFeed(withType: postsFeedType, andLimit: postsLimit) { [weak self] (displayedPosts, errorAPI) in
            guard let strongSelf = self else { return }
            
            guard errorAPI == nil else {
                Utils.showAlertView(withTitle: errorAPI!.caseInfo.title, andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
                return
            }
            
            let newDisplayedPosts = displayedPosts!.filter({ displayedPost -> Bool in
                !strongSelf.displayedPosts.contains(where: { $0.id == displayedPost.id })
            })

            strongSelf.displayedPosts.append(contentsOf: newDisplayedPosts)
            
//            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.displayedPosts)
//            strongSelf.postsFeedView.didLoadPosts()

            strongSelf.loadUsers(byNames: strongSelf.displayedPosts.map({ $0.authorName }))
        }
    }
    
    func loadNext() {
        Logger.log(message: "Success", event: .severe)

        postsLimit += batchCount
        loadPostsFeed()
    }
    
    /// Load Users from Posts in Feed
    private func loadUsers(byNames userNames: [String]) {
        Logger.log(message: "Success", event: .severe)

        self.userManager.loadUsers(byNames: userNames) { [weak self] (displayedUsers, errorAPI) in
            guard let strongSelf = self else { return }
           
            guard errorAPI == nil else {
                Utils.showAlertView(withTitle: errorAPI!.caseInfo.title, andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
                return
            }
            
            for (index, post) in strongSelf.displayedPosts.enumerated() {
                let postUser = displayedUsers!.first(where: { $0.name == post.authorName })
                strongSelf.displayedPosts[index].author = postUser
            }
            
//            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.displayedPosts)
//            strongSelf.postsFeedView.didLoadPostsAuthors()
            
//            for index in 0..<strongSelf.displayedPosts.count {
//                strongSelf.loadRepliesForPost(at: index)
//            }
        }
    }
    
    
    // FIXME: - REMOVE COMMENTS AFTER ADD REPLIES
    /*
    func loadRepliesForPost(at index: Int) {
        Logger.log(message: "Success", event: .severe)

        let displayedPost = self.displayedPosts[index]
        replyManager.loadRepliesForPost(withPermalink: displayedPost.permlink, authorUsername: displayedPost.authorName) { [weak self] replies, error in
            guard let strongSelf = self else {return}

            guard error == nil else {
                Utils.showAlertView(withTitle: errorAPI!.caseInfo.title, andMessage: errorAPI!.caseInfo.message, needCancel: false, completion: { _ in })
                return
            }
            
            strongSelf.displayedPosts[index].replies = replies
            strongSelf.postsItems[index] = strongSelf.parsePostModel(strongSelf.displayedPosts[index])
            strongSelf.postsFeedView.didLoadPostReplies(at: index)
        }
    }
    */
    
    func getPostsViewModels() -> [PostsFeedViewModel] {
        return postsItems
    }
    
    func getPostViewModel(at index: Int) -> PostsFeedViewModel? {
        Logger.log(message: "Success", event: .severe)

        guard index < postsItems.count else { return nil }
        return postsItems[index]
    }
    
    // TEMPORARY
    func parsePostModel(_ postModel: PostModel) -> PostsFeedViewModel {
        return  PostsFeedViewModel(authorName:          postModel.authorName,
                                   authorAvatarUrl:     postModel.author?.pictureURL,
                                   articleTitle:        postModel.title,
                                   reblogAuthorName:    postModel.reblogAuthorName,
                                   theme:               postModel.category,
                                   articleBody:         postModel.body,
                                   postDescription:     postModel.description,
                                   imagePictureUrl:     postModel.pictureUrl,
                                   tags:                postModel.tags,
                                   upvoteAmount:        "\(postModel.votes.count)",
                                   commentsAmount:      postModel.replies == nil ? "-" :"\(postModel.replies!.count)",
                                   didUpvote:           postModel.isVoteAllow,
                                   didComment:          postModel.isCommentAllow)
    }
    
    func parse(posts: [PostModel]) -> [PostsFeedViewModel] {
        return posts.map({ model -> PostsFeedViewModel in
            return parsePostModel(model)
        })
    }
}
