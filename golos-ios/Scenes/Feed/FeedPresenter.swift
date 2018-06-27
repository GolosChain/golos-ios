//
//  FeedPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation
import GoloSwift

protocol FeedPresenterProtocol: class {
    func getPostsFeedTypeArray() -> [PostsFeedType]
    func nextPostsFeedType(_ current: PostsFeedType) -> PostsFeedType?
    func previousPostsFeedType(_ current: PostsFeedType) -> PostsFeedType?
    func getPostsFeedType(at index: Int) -> PostsFeedType?
    func getIndex(for type: PostsFeedType) -> Int?
}

protocol FeedViewProtocol: class {
}

class FeedPresenter: NSObject {
    private var postsFeedTypeArray = [PostsFeedType]()
    
    weak var feedView: FeedViewProtocol!
    
    override init() {
        super.init()
        
        postsFeedTypeArray = [
            .lenta,
            .popular,
            .actual,
            .new,
            .promoted
        ]
    }
}


// MARK: FeedPresenterProtocol
extension FeedPresenter: FeedPresenterProtocol {
    func getPostsFeedTypeArray() -> [PostsFeedType] {
        // FIXME: - ADD REAL USER STATE
        if 2/3 == 1 {
            postsFeedTypeArray.remove(at: 0)
        }
        
        return postsFeedTypeArray
    }
    
    func getPostsFeedType(at index: Int) -> PostsFeedType? {
        guard index < postsFeedTypeArray.count else { return nil }
        return postsFeedTypeArray[index]
    }
    
    func nextPostsFeedType(_ current: PostsFeedType) -> PostsFeedType? {
        guard let currentIndex = postsFeedTypeArray.index(of: current) else { return nil }
        guard currentIndex < postsFeedTypeArray.count - 1 else { return nil }
        
        let nextType = postsFeedTypeArray[currentIndex + 1]
        return nextType
    }
    
    func previousPostsFeedType(_ current: PostsFeedType) -> PostsFeedType? {
        guard let currentIndex = postsFeedTypeArray.index(of: current) else { return nil }
        guard currentIndex > 0 else { return nil }
        
        let previousType = postsFeedTypeArray[currentIndex - 1]
        return previousType
    }
    
    func getIndex(for type: PostsFeedType) -> Int? {
        guard let index = postsFeedTypeArray.index(of: type) else {
            return nil
        }
        
        return index
    }
}
