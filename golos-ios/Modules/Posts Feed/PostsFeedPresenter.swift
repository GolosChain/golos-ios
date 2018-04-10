//
//  FeedTabPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol PostsFeedPresenterProtocol: class {
    func setPostsFeedType(_ type: PostsFeedType)
    func getPostsFeedType() -> PostsFeedType
    
    func fetchPosts()
    func loadPosts()
    
    func loadNext()
    
    func getPostsViewModels() -> [PostsFeedViewModel]
    func getPostViewModel(at index: Int) -> PostsFeedViewModel?
    
    func getPostPermalinkAndAuthorName(at index: Int) -> (permalink: String, author: String)
    func getUser(at index: Int) -> UserModel?
//    func loadRepliesForPost(at index: Int)
}

protocol PostsFeedViewProtocol: class {
    func didFetchPosts()
    func didLoadPosts()
    func didLoadPostsAuthors()
    func didLoadPostReplies(at index: Int)
}

class PostsFeedPresenter: NSObject {
    weak var postsFeedView: PostsFeedViewProtocol!
    
    private var postsFeedType: PostsFeedType = .new
    private var postsItems = [PostsFeedViewModel]()
    private var posts = [PostModel]()
    private var postsAmount = 10
    private let batchCount = 10
    
    private let postsFeedManager = PostsFeedManager()
    private let userManager = UserManager()
    private let replyManager = ReplyManager()
}

extension PostsFeedPresenter: PostsFeedPresenterProtocol {
    func getUser(at index: Int) -> UserModel? {
        let post = posts[index]
        return post.author
    }
    
    func getPostPermalinkAndAuthorName(at index: Int) -> (permalink: String, author: String) {
        let post = posts[index]
        return (post.permalink, post.authorName)
    }
    
    func setPostsFeedType(_ type: PostsFeedType) {
        self.postsFeedType = type
    }
    
    func getPostsFeedType() -> PostsFeedType {
        return self.postsFeedType
    }
    
    func fetchPosts() {
        
    }
    
    func loadPosts() {
        postsFeedManager.loadFeed(with: postsFeedType, amount: postsAmount) { [weak self] posts, error in
            guard let strongSelf = self else { return }
            guard  error == nil else {
                return
            }
            
            let newPosts = posts.filter({ model -> Bool in
                !strongSelf.posts.contains(where: {$0.postId == model.postId})
            })
            
            strongSelf.posts.append(contentsOf: newPosts)
            
            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.posts)
            strongSelf.postsFeedView.didLoadPosts()

            strongSelf.loadUsers(for: strongSelf.posts)
        }
    }
    
    func loadNext() {
        postsAmount += batchCount
        loadPosts()
    }
    
    private func loadUsers(for posts: [PostModel]) {
        let usernames = posts.map { post -> String in
            return post.authorName
        }
        
        userManager.loadUsers(usernames) { [weak self] users, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                return
            }
            
            for (index, post) in strongSelf.posts.enumerated() {
                let postUser = users.first(where: {$0.name == post.authorName})
                strongSelf.posts[index].author = postUser
            }
            
            strongSelf.postsItems = strongSelf.parse(posts: strongSelf.posts)
            strongSelf.postsFeedView.didLoadPostsAuthors()
            
            for index in 0..<strongSelf.posts.count {
//                for (index, _) in strongSelf.posts.enumerated() {
                strongSelf.loadRepliesForPost(at: index)
            }
        }
    }
    
    func loadRepliesForPost(at index: Int) {
        let post = self.posts[index]
        replyManager.loadRepliesForPost(withPermalink: post.permalink,
                                        authorUsername: post.authorName) { [weak self] replies, error in
            guard let strongSelf = self else {return}
            guard error == nil else {
                return
            }
            
            strongSelf.posts[index].replies = replies
            strongSelf.postsItems[index] = strongSelf.parsePostModel(strongSelf.posts[index])
            strongSelf.postsFeedView.didLoadPostReplies(at: index)
        }
    }
    
    func getPostsViewModels() -> [PostsFeedViewModel] {
        return postsItems
    }
    
    func getPostViewModel(at index: Int) -> PostsFeedViewModel? {
        guard index < postsItems.count else { return nil }
        return postsItems[index]
    }
    
    // TEMPORARY
    func parsePostModel(_ postModel: PostModel) -> PostsFeedViewModel {
        return PostsFeedViewModel(authorName: postModel.authorName,
                                  authorAvatarUrl: postModel.author?.pictureUrl,
                                  articleTitle: postModel.title,
                                  reblogAuthorName: postModel.reblogAuthorName,
                                  theme: postModel.category,
                                  articleBody: postModel.body,
                                  postDescription: postModel.description,
                                  imagePictureUrl: postModel.pictureUrl,
                                  tags: postModel.tags,
                                  upvoteAmount: "\(postModel.votes.count)",
            commentsAmount: postModel.replies == nil ? "-" :"\(postModel.replies!.count)",
            didUpvote: postModel.isVoteAllow,
            didComment: postModel.isCommentAllow)
    }
    
    func parse(posts: [PostModel]) -> [PostsFeedViewModel] {
        return posts.map({ model -> PostsFeedViewModel in
            return parsePostModel(model)
        })
    }
}

////FAKE DATA
//extension PostsFeedPresenter {
//    // swiftlint:disable line_length
//    private func fetchFakeAcrticles() -> [PostsFeedViewModel] {
//        let fakeArticle1 = PostsFeedViewModel(authorName: "digitalbeauty",
//                                               authorAvatarUrl: "https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_1280.png",
//                                               articleTitle: "Когда женственность настолько крута, что дух захватывает ...",
//                                               reblogAuthorName: "egorfedorov",
//                                               theme: "Технологии",
//                                               articleImageUrl: "https://cdn.theatlantic.com/assets/media/img/mt/2017/06/GettyImages_675371680/lead_960.jpg?1498239007",
//                                               articleBody: "Японская культура настолько загадочна и самобытна, что понять её может не каждый. Традиции и нравы, искусство и обычаи Страны восходящего солнца интересно познавать.\n\nИскусство Японии способно передать многие особенности культуры и менталитета, показать сущность национального характера жителей, населяющих эту страну. Сегодня расскажу об истории увлекательных кукольных представлений, которые получили своё развитие ещё в эпоху Эдо. В те сложные для Японии годы, театр не был доступен всем слоям общества, и только кукольные театры могли посещать бедные жители.",
//                                               upvoteAmount: "$23.22",
//                                               commentsAmount: "32",
//                                               didUpvote: true,
//                                               didComment: false)
//        let fakeArticle2 = PostsFeedViewModel(authorName: "innusik",
//                                                authorAvatarUrl: "https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_1280.png",
//                                                articleTitle: "Покушение на президента СССР Михаила Горбачева",
//                                                reblogAuthorName: nil,
//                                                theme: "psk",
//                                                articleImageUrl: "https://cdn.theatlantic.com/assets/media/img/mt/2017/06/GettyImages_675371680/lead_960.jpg?1498239007",
//                                                articleBody: "Мировая история знает множество покушений на лидеров государств. Многие из них были удачными, многие закончились провалом. Российская история также насыщена подобными фактами. Одной из самых ярких и как не печально это признать удачных, террористических попыток ликвидации против главы государства в России считается смерть императора Александра II в 1881 году. До этого на него были совершены ещё несколько, но неудачных попыток убийства. Последним же покушением на главу государства в России стало попытка ликвидировать последнего генерального секретаря СССР М.С. Горбачёва в 1990 году.",
//                                                upvoteAmount: "$233.22",
//                                                commentsAmount: "100",
//                                                didUpvote: false,
//                                                didComment: true)
//        return [fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2]
//    }
//    // swiftlint:enable line_length
//}
