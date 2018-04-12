//
//  AnswersFeedPresenter.swift
//  Golos
//
//  Created by Grigory on 14/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol AnswersFeedPresenterProtocol: class {
    func fetchAnswers()
    func loadAnswers()
    
    func getAnswersViewModels() -> [AnswersFeedViewModel]
    func getAnswersViewModel(at index: Int) -> AnswersFeedViewModel?
}

protocol AnswersFeedViewProtocol: class {
    
}

class AnswersFeedPresenter: NSObject, AnswersFeedPresenterProtocol {
    // MARK: - Properties
    weak var answersFeedView: AnswersFeedViewProtocol!
    private var answersItems = [AnswersFeedViewModel]()
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - AnswersFeedPresenterProtocol
    func fetchAnswers() {
        answersItems = fetchFakeAnswers()
    }
    
    func loadAnswers() {
        
    }
    
    func getAnswersViewModels() -> [AnswersFeedViewModel] {
        return answersItems
    }
    
    func getAnswersViewModel(at index: Int) -> AnswersFeedViewModel? {
        guard index < answersItems.count else { return nil }
        return answersItems[index]
    }
}


// MARK: - Extensions
extension AnswersFeedPresenter {
    // swiftlint:disable line_length
    private func fetchFakeAnswers() -> [AnswersFeedViewModel] {
        let fakeAnswer1 = AnswersFeedViewModel(authorName: "digitalbeauty", authorPictureUrl: nil, authorVoicePower: "23", text: "Услышав, что приговор остается в силе Слободан Пральяк совершил что-то там", time: "4 дн назад", type: .comment)
        let fakeAnswer2 = AnswersFeedViewModel(authorName: "konstantin konstantinopolskiy", authorPictureUrl: nil, authorVoicePower: "23", text: "Макларен призвал МОК применить к России коллективные санкции", time: "5 дн назад", type: .post)
        
        return [fakeAnswer1, fakeAnswer2, fakeAnswer1, fakeAnswer2, fakeAnswer1, fakeAnswer2, fakeAnswer1, fakeAnswer2]
    }
    // swiftlint:enable line_length
}
