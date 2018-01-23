//
//  FeedTabPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 22/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol FeedTabPresenterProtocol: class {
    func setFeedTab(_ tab: FeedTab)
    func getFeedTab() -> FeedTab
    
    func getArticleModels() -> [FeedArticleViewModel]
    func getArticleModel(at index: Int) -> FeedArticleViewModel?
    
    func fetchArticles()
    func loadArticles()
    
    func makeExpanded(_ isExpanded: Bool, at index: Int)
    func isExpanded(at index: Int) -> Bool
}

protocol FeedTabViewProtocol: class {
    func didFetchArticles()
    func didLoadArticles()
}

class FeedTabPresenter: NSObject {
    weak var feedTabView: FeedTabViewProtocol!
    
    private var feedTab = FeedTab(type: .popular)
    
    private var articleModels = [FeedArticleViewModel]()
    private var expandedArticles = [Int]()
}

extension FeedTabPresenter: FeedTabPresenterProtocol {
    func getFeedTab() -> FeedTab {
        return feedTab
    }
    
    func setFeedTab(_ tab: FeedTab) {
        feedTab = tab
    }
    
    func getArticleModels() -> [FeedArticleViewModel] {
        return articleModels
    }
    
    func getArticleModel(at index: Int) -> FeedArticleViewModel? {
        guard index < articleModels.count else {return nil}
        return articleModels[index]
    }
    
    func fetchArticles() {
        articleModels = fetchFakeAcrticles()
    }
    
    func loadArticles() {
        
    }
    
    func makeExpanded(_ isExpanded: Bool, at index: Int) {
        if isExpanded {
            expandedArticles.append(index)
        } else {
            expandedArticles = expandedArticles.filter{$0 != index}
        }
    }
    
    func isExpanded(at index: Int) -> Bool {
        return expandedArticles.contains(index)
    }
}

//FAKE DATA
extension FeedTabPresenter {
    private func fetchFakeAcrticles() -> [FeedArticleViewModel] {
        let fakeArticle1 = FeedArticleViewModel(authorName: "digitalbeauty",
                                               authorAvatarUrl: "https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_1280.png",
                                               articleTitle: "Когда женственность настолько крута, что дух захватывает ...",
                                               reblogAuthorName: "egorfedorov",
                                               theme: "Технологии",
                                               articleImageUrl: "https://cdn.theatlantic.com/assets/media/img/mt/2017/06/GettyImages_675371680/lead_960.jpg?1498239007",
                                               articleBody: "Японская культура настолько загадочна и самобытна, что понять её может не каждый. Традиции и нравы, искусство и обычаи Страны восходящего солнца интересно познавать.\n\nИскусство Японии способно передать многие особенности культуры и менталитета, показать сущность национального характера жителей, населяющих эту страну. Сегодня расскажу об истории увлекательных кукольных представлений, которые получили своё развитие ещё в эпоху Эдо. В те сложные для Японии годы, театр не был доступен всем слоям общества, и только кукольные театры могли посещать бедные жители.",
                                               upvoteAmount: "$23.22",
                                               commentsAmount: "32",
                                               didUpvote: true,
                                               didComment: false)
        let fakeArticle2 = FeedArticleViewModel(authorName: "innusik",
                                                authorAvatarUrl: "https://cdn.pixabay.com/photo/2016/08/20/05/38/avatar-1606916_1280.png",
                                                articleTitle: "Покушение на президента СССР Михаила Горбачева",
                                                reblogAuthorName: nil,
                                                theme: "psk",
                                                articleImageUrl: "https://cdn.theatlantic.com/assets/media/img/mt/2017/06/GettyImages_675371680/lead_960.jpg?1498239007",
                                                articleBody: "Мировая история знает множество покушений на лидеров государств. Многие из них были удачными, многие закончились провалом. Российская история также насыщена подобными фактами. Одной из самых ярких и как не печально это признать удачных, террористических попыток ликвидации против главы государства в России считается смерть императора Александра II в 1881 году. До этого на него были совершены ещё несколько, но неудачных попыток убийства. Последним же покушением на главу государства в России стало попытка ликвидировать последнего генерального секретаря СССР М.С. Горбачёва в 1990 году.",
                                                upvoteAmount: "$233.22",
                                                commentsAmount: "100",
                                                didUpvote: false,
                                                didComment: true)
        return [fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2]
    }
}
