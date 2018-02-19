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
    
    func getPostsViewModels() -> [PostsFeedViewModel]
    func getPostViewModel(at index: Int) -> PostsFeedViewModel?
}

protocol PostsFeedViewProtocol: class {
    func didFetchPosts()
    func didLoadPosts()
}

class PostsFeedPresenter: NSObject {
    weak var postsFeedView: PostsFeedViewProtocol!
    
    private var postsFeedType: PostsFeedType = .new
    private var postsItems = [PostsFeedViewModel]()
    
    private let postsManager = PostsManager()
    private let userManager = UserManager()
}

extension PostsFeedPresenter: PostsFeedPresenterProtocol {
    func setPostsFeedType(_ type: PostsFeedType) {
        self.postsFeedType = type
    }
    
    func getPostsFeedType() -> PostsFeedType {
        return self.postsFeedType
    }
    
    func fetchPosts() {
        
    }
    
    func loadPosts() {
        postsManager.loadFeed(with: postsFeedType, amount: 10) { [weak self] posts, error in
            guard let strongSelf = self else { return }
            guard  error == nil else {
                return
            }
            
            strongSelf.postsItems = strongSelf.parse(posts: posts)
            strongSelf.postsFeedView.didLoadPosts()

            strongSelf.loadUsers(for: posts)
        }
    }
    
    private func loadUsers(for posts: [PostModel]) {
        let usernames = posts.map { post -> String in
            return post.authorName
        }
        
        userManager.loadUsers(usernames) { [weak self] users, error in
            guard let strongSelf = self else { return }
            guard  error == nil else {
                return
            }
            
            let updatedWithUserPosts = posts.map({ post -> PostModel in
                let postUser = users.first(where: {$0.name == post.authorName})
                var newPost = post
                newPost.author = postUser
                return newPost
            })
            
            strongSelf.postsItems = strongSelf.parse(posts: updatedWithUserPosts)
            strongSelf.postsFeedView.didLoadPosts()
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
    func parse(posts: [PostModel]) -> [PostsFeedViewModel] {
        return posts.map({ model -> PostsFeedViewModel in
          
            
            return PostsFeedViewModel(authorName: model.authorName,
                                      authorAvatarUrl: model.author?.pictureUrl,
                                      articleTitle: model.title,
                                      reblogAuthorName: "b",
                                      theme: model.category,
                                      articleBody: model.body,
                                      postDescription: model.description,
                                      imagePictureUrl: model.pictureUrl,
                                      upvoteAmount: "\(model.votes.count)",
                                      commentsAmount: "2",
                                      didUpvote: model.isVoteAllow,
                                      didComment: model.isCommentAllow)
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

