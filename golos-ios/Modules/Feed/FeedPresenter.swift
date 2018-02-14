//
//  FeedPresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 21/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol FeedPresenterProtocol: class {
    func getPostsFeedTypeArray() -> [PostsFeedType]
    func nextPostsFeedType(_ current: PostsFeedType) -> PostsFeedType?
    func previousPostsFeedType(_ current: PostsFeedType) -> PostsFeedType?
    func getPostsFeedType(at index: Int) -> PostsFeedType?
}

protocol FeedViewProtocol: class {
}

class FeedPresenter: NSObject {
    private var postsFeedTypeArray = [PostsFeedType]()
    
    weak var feedView: FeedViewProtocol!
    
    override init() {
        super.init()
        
        postsFeedTypeArray = [
            .popular,
            .hot,
            .new,
            .promoted
        ]
    }
}


// MARK: FeedPresenterProtocol
extension FeedPresenter: FeedPresenterProtocol {
    func getPostsFeedTypeArray() -> [PostsFeedType] {
        return postsFeedTypeArray
    }
    
    func getPostsFeedType(at index: Int) -> PostsFeedType? {
        guard index < postsFeedTypeArray.count - 1 else { return nil }
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
}
