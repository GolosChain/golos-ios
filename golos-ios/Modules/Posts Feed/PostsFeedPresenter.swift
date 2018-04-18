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
    func getPostPermalinkAndAuthorName(at index: Int) -> (permalink: String, author: String)
    
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
    
    private var postsFeedType: PostsFeedType = .new
    private var postsItems = [PostsFeedViewModel]()
    private var displayedPosts = [DisplayedPost]()
    private var postsLimit = webSocketLimit
    private let batchCount = 10
    
    private let postsFeedManager = PostsFeedManager()
    private let userManager = UserManager()
    private let replyManager = ReplyManager()
}


// MARK: - PostsFeedPresenterProtocol
extension PostsFeedPresenter: PostsFeedPresenterProtocol {
//    func getUser(at index: Int) -> UserModel? {
//        Logger.log(message: "Success", event: .severe)
//
//        let displayedPost = displayedPosts[index]
//        return displayedPost.author
//    }
    
    func getPostPermalinkAndAuthorName(at index: Int) -> (permalink: String, author: String) {
        Logger.log(message: "Success", event: .severe)

        let displayedPost = displayedPosts[index]
        return (displayedPost.permlink, displayedPost.authorName)
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
                Utils.showAlertView(withTitle: "Error", andMessage: errorAPI!.localizedDescription, needCancel: false, completion: { _ in })
                return
            }
            
            let newDisplayedPosts = displayedPosts!.filter({ displayedPost -> Bool in
                !strongSelf.displayedPosts.contains(where: { $0.id == displayedPost.id })
            })

            strongSelf.displayedPosts.append(contentsOf: newDisplayedPosts)
            
//            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.displayedPosts)
//            strongSelf.postsFeedView.didLoadPosts()

            strongSelf.loadUsers(forDisplayedPosts: strongSelf.displayedPosts)
        }
    }
    
    func loadNext() {
        Logger.log(message: "Success", event: .severe)

        postsLimit += batchCount
        loadPostsFeed()
    }
    
    private func loadUsers(forDisplayedPosts displayedPost: [DisplayedPost]) {
        Logger.log(message: "Success", event: .severe)

        let authorNames = displayedPost.map({ $0.authorName })
        
        self.userManager.loadUsers(byNames: authorNames) { [weak self] (users, error) in
            guard let strongSelf = self else { return }
           
            guard error == nil else {
                Utils.showAlertView(withTitle: "Error", andMessage: "\(error!.localizedDescription)", needCancel: false, completion: { _ in })
                return
            }
            
            for (index, post) in strongSelf.displayedPosts.enumerated() {
                let postUser = users!.first(where: {$0.name == post.authorName})
//                strongSelf.displayedPosts[index].author = postUser
            }
            
//            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.displayedPosts)
//            strongSelf.postsFeedView.didLoadPostsAuthors()
            
            for index in 0..<strongSelf.displayedPosts.count {
//                for (index, _) in strongSelf.posts.enumerated() {
                strongSelf.loadRepliesForPost(at: index)
            }
        }
    }
    
    func loadRepliesForPost(at index: Int) {
        Logger.log(message: "Success", event: .severe)

        let displayedPost = self.displayedPosts[index]
        replyManager.loadRepliesForPost(withPermalink: displayedPost.permlink, authorUsername: displayedPost.authorName) { [weak self] replies, error in
            guard let strongSelf = self else {return}

            guard error == nil else {
                Utils.showAlertView(withTitle: "Error", andMessage: "\(error!.localizedDescription)", needCancel: false, completion: { _ in })
                return
            }
            
//            strongSelf.displayedPosts[index].replies = replies
//            strongSelf.postsItems[index] = strongSelf.parsePostModel(strongSelf.displayedPosts[index])
//            strongSelf.postsFeedView.didLoadPostReplies(at: index)
        }
    }
    
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
