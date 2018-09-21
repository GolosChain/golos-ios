//
//  PostCreateInteractor.swift
//  golos-ios
//
//  Created by msm72 on 11.06.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift

// MARK: - Business Logic protocols
protocol PostCreateBusinessLogic {
    func save(tags: [Tag]?)
    func save(commentBody: String)
    func save(commentTitle: String)
    func save(attachments: [Attachment])
    func publishItem(withRequestModel requestModel: PostCreateModels.Item.RequestModel)
}

protocol PostCreateDataStore {
    var tags: [Tag]? { get set }
    var attachments: [Attachment]? { get set }
    var commentBody: String? { get set }
    var commentTitle: String? { get set }
    var commentParentAuthor: String? { get set }
    var commentParentPermlink: String? { get set }
}

class PostCreateInteractor: PostCreateBusinessLogic, PostCreateDataStore {
    // MARK: - Properties
    var presenter: PostCreatePresentationLogic?
    var worker: PostCreateWorker?

    // PostCreateDataStore protocol implementation
    var tags: [Tag]?
    var attachments: [Attachment]?
    var commentBody: String?
    var commentTitle: String?
    var commentParentAuthor: String?
    var commentParentPermlink: String?

    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    

    // MARK: - Business logic implementation
    func save(tags: [Tag]?) {
        self.tags = tags
    }
    
    func save(commentBody: String) {
        self.commentBody    =   commentBody
    }
    
    func save(commentTitle: String) {
        self.commentTitle   =   commentTitle
    }
    
    func save(attachments: [Attachment]) {
        self.attachments    =   attachments
    }
    
    func publishItem(withRequestModel requestModel: PostCreateModels.Item.RequestModel) {
        worker = PostCreateWorker()

        // Create markdown titles for all images & links
        worker?.createSignatures(forImagesIn: self.attachments!, completion: { [weak self] attachments in
            self?.save(attachments: attachments)
            
            // API 'get_content'
            let content     =   RequestParameterAPI.Content(author: User.current!.name, permlink: (self?.tags!.first!.title!)!.transliteration())
            
            RestAPIManager.loadPostPermlink(byContent: content, completion: { errorAPI in
                guard errorAPI.caseInfo.message != "No Internet Connection" else {
                    let responseModel       =   PostCreateModels.Item.ResponseModel(errorAPI: errorAPI)
                    self?.presenter?.presentPublishItem(fromResponseModel: responseModel)
                   
                    return
                }
                
                // API 'Create new post'
                let jsonMetadataString      =   ("{\"tags\":[\"" + (self?.tags!.compactMap({ $0.title!.transliteration() }).joined(separator: ","))! + "\"]")
                                                    .replacingOccurrences(of: ",", with: "\",\"") + ",\"app\":\"golos.io/0.1\",\"format\":\"markdown\"}"

                Logger.log(message: "\njsonMetadataString:\n\t\(jsonMetadataString)", event: .debug)
                
                // Create Comment with transliteration inside init
                let comment                 =   RequestParameterAPI.Comment(parentAuthor:       "",
                                                                            parentPermlink:     (self?.tags!.first!.title)!.transliteration(),
                                                                            author:             User.current!.name,
                                                                            title:              (self?.commentTitle)!.transliteration(),
                                                                            body:               (self?.commentBody!)!,
                                                                            jsonMetadata:       jsonMetadataString,
                                                                            needTiming:         errorAPI.caseInfo.message.contains("timing"),
                                                                            attachments:        self?.attachments)
                
                let operationAPIType        =   OperationAPIType.createPost(operations: [comment])
                
                broadcast.executePOST(requestByOperationAPIType:    operationAPIType,
                                      userName:                     User.current!.name,
                                      onResult:                     { [weak self] responseAPIResult in
                                        var errorAPI: ErrorAPI?
                                        
                                        if let error = (responseAPIResult as! ResponseAPIBlockchainPostResult).error {
                                            errorAPI        =   ErrorAPI.requestFailed(message: error.message)
                                        }
                                        
                                        let responseModel   =   PostCreateModels.Item.ResponseModel(errorAPI: errorAPI)
                                        self?.presenter?.presentPublishItem(fromResponseModel: responseModel)
                    },
                                      onError: { errorAPI in
                                        Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                        let responseModel   =   PostCreateModels.Item.ResponseModel(errorAPI: errorAPI)
                                        self?.presenter?.presentPublishItem(fromResponseModel: responseModel)
                })
            })
        })
    }
}
