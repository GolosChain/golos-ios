//
//  FeedTabPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

protocol PostsFeedPresenterProtocol: class {
    func loadNext(withType type: PostsFeedType)
//    func loadPostsFeed()
    func loadPostsFeed(withType type: PostsFeedType, andDiscussion discussion: RequestParameterAPI.Discussion)
    
    func getFeedPostsType() -> PostsFeedType
//    func getUser(at index: Int) -> UserModel?
    func setPostsFeedType(_ type: PostsFeedType)
    func getDisplayedPosts() -> [DisplayedPost]
    func getDisplayedPost(byIndex index: Int) -> DisplayedPost?
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
    
    private var displayedPosts = [DisplayedPost]()
    private var postsFeedType: PostsFeedType = .new

//    private let userManager = UserManager()
//    private let replyManager = ReplyManager()
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
    func loadPostsFeed(withType type: PostsFeedType, andDiscussion discussion: RequestParameterAPI.Discussion) {
        Logger.log(message: "Success", event: .severe)

        if (type == .popular || type == .lenta) && displayedPostsItems.count > 0 && discussion.start_author == nil {
            // Prepare & Display feed posts
            self.displayedPosts.append(contentsOf: displayedPostsItems)
            self.postsFeedView.didLoadPosts()
            displayedPostsItems = [DisplayedPost]()
        }

        else {
            postsFeedManager.loadPostsFeed(withType: type, andDiscussion: discussion, completion: { [weak self] (displayedPosts, errorAPI) in
                guard let selfStrong = self else { return }
                
                guard errorAPI == nil else {
                    return
                }
                
                guard displayedPosts!.count > 0 else {
                    selfStrong.postsFeedView.didLoadPosts()
                    return
                }
                
                let newDisplayedPosts = displayedPosts!.filter({ displayedPost -> Bool in
                    !selfStrong.displayedPosts.contains(where: { $0.id == displayedPost.id })
                })
                
                // Prepare & Display feed posts
                selfStrong.displayedPosts.append(contentsOf: newDisplayedPosts)
                selfStrong.postsFeedView.didLoadPosts()
                
                // FIXME: - ADD LOAD USERS AVATARS
//            selfStrong.loadUsers(byNames: selfStrong.displayedPosts.map({ $0.authorName }))
            })
        }
    }
    
    func loadNext(withType type: PostsFeedType) {
        Logger.log(message: "Success", event: .severe)

        // Load last post
        if let lastFeedPost = self.displayedPosts.last {
            self.loadPostsFeed(withType:        type,
                               andDiscussion:   RequestParameterAPI.Discussion.init(limit:           loadDataLimit,
                                                                                    startAuthor:     lastFeedPost.authorName,
                                                                                    startPermlink:   lastFeedPost.permlink))
        }
    }
    

    // FIXME: - ADD LOAD USERS AVATARS
    /*
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
            
            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.displayedPosts)
            strongSelf.postsFeedView.didLoadPostsAuthors()
            
            for index in 0..<strongSelf.displayedPosts.count {
                strongSelf.loadRepliesForPost(at: index)
            }
        }
    }
    */
    
    
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
    
    func getDisplayedPosts() -> [DisplayedPost] {
        return self.displayedPosts
    }
    
    func getDisplayedPost(byIndex index: Int) -> DisplayedPost? {
        Logger.log(message: "Success", event: .severe)

        guard index < self.displayedPosts.count else { return nil }
        
        return self.displayedPosts[index]
    }
}
