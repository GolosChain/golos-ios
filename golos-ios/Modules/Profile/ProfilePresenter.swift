//
//  ProfilePresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfilePresenterProtocol: class {
//    func refresh()
    
    func getProfileData() -> ProfileDataViewModel
    
    func getFeedModels() -> [FeedArticleViewModel]
    func getArticleModel(at index: Int) -> FeedArticleViewModel?
    
    func fetchProfileData()
    func loadProfileData()
    
    func loadFeed()
    func fetchFeed()
    func fetchNext()
    
    func getActiveFeedTab() -> ProfileFeedTab
    func setActiveTab(_ tab: ProfileFeedTab)
    func getFeedTab(at index: Int) -> ProfileFeedTab?
}

protocol ProfileViewProtocol: class {
    func didLoadArticles()
    func didLoadProfileData()
    func didRefreshSuccess()
    func didChangedFeedTab(isForward: Bool, previousAmount: Int)
}

class ProfilePresenter: NSObject {
    //MARK: View
    weak var profileView: ProfileViewProtocol!
    
    private var profileData = ProfileDataViewModel()
    private var feedData = [FeedArticleViewModel]()
    
    private var feedTabs: [ProfileFeedTab]!
    private var activeFeedTab = ProfileFeedTab(type: .posts)
    
    override init() {
        super.init()
        
        self.feedTabs = [
            ProfileFeedTab(type: .posts),
            ProfileFeedTab(type: .answers),
            ProfileFeedTab(type: .favorite)
        ]
        
        guard let first = self.feedTabs.first else {
            return
        }
        
        self.activeFeedTab = first
    }
    
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func getProfileData() -> ProfileDataViewModel {
        return profileData
    }
    
    func getFeedModels() -> [FeedArticleViewModel] {
        return feedData
    }
    
    func getArticleModel(at index: Int) -> FeedArticleViewModel? {
        guard index < feedData.count else {return nil}
        return feedData[index]
    }
    
    func fetchProfileData() {
        profileData = fetchFakeProfileData()
        profileView.didLoadArticles()
    }
    
    func loadProfileData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.profileView.didLoadProfileData()
        }
    }
    
    func loadFeed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.profileView.didLoadArticles()
        }
    }
    
    func fetchFeed() {
        feedData = fetchFakeAcrticles()
    }
    
    func fetchNext() {
    
    }

    func getActiveFeedTab() -> ProfileFeedTab {
        return self.activeFeedTab
    }
    
    func setActiveTab(_ tab: ProfileFeedTab) {
        guard tab != activeFeedTab,
            let index = feedTabs.index(of: tab) else {return}
        
        let previousAmount = feedData.count
        var isForward = true
        if let previousIndex = feedTabs.index(of: self.activeFeedTab) {
            isForward = previousIndex < index
        }
        
        self.activeFeedTab = tab
        
        fetchFeed()
        
        profileView.didChangedFeedTab(isForward: isForward, previousAmount: previousAmount)
    }
    
    func getFeedTab(at index: Int) -> ProfileFeedTab? {
        guard index >= 0 && index < feedTabs.count else {return nil}
        let tab = feedTabs[index]
        return tab
    }
}


//MARK: Fake data
extension ProfilePresenter {
    private func fetchFakeProfileData() -> ProfileDataViewModel {
        let fakeData = ProfileDataViewModel(
            name: "Konstantin Konstantinopolskiy",
            avatarUrlString: nil,
            starsString: "10",
            rankString: "Дельфин",
            information: "Умение искать, а главное, находить компромисс с каждым днём становится крайне полезным навыком. Однако многие и сегодня в порыве эмоций или на поводу собственного окружения делают сомнительный выбор в пользу развития событий по конфликтному сценарию.",
            postsAmountString: "5",
            subscribersAmountString: "100",
            subscriptionsAmountString: "12")
        return fakeData
    }
    
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
        return [fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2, fakeArticle1, fakeArticle2]
    }
}

