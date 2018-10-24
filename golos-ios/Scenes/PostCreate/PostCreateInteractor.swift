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
    func postingItem(withRequestModel requestModel: PostCreateModels.Item.RequestModel)
}

protocol PostCreateDataStore {
    var tags: [Tag]? { get set }
    var attachments: [Attachment]? { get set }
    var commentBody: String? { get set }
    var commentTitle: String? { get set }
    var commentParentAuthor: String? { get set }
    var commentParentPermlink: String? { get set }
    var commentParentTag: String? { get set }
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
    var commentParentTag: String?
    
    
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
    
    func postingItem(withRequestModel requestModel: PostCreateModels.Item.RequestModel) {
        worker = PostCreateWorker()

        // Create markdown titles for all images & links
        worker?.createSignatures(forImagesIn: self.attachments!, completion: { [weak self] attachments in
            self?.save(attachments: attachments)
            
            // API
            switch requestModel.sceneType {
            case .createPost:
                // API 'get_content'
                self?.worker?.load(postPermlink: (self?.tags?.first?.title)!.transliteration(forPermlink: false), completion: { errorAPI in
                    guard errorAPI.caseInfo.message != "No Internet Connection" else {
                        let responseModel = PostCreateModels.Item.ResponseModel(errorAPI: errorAPI)
                        self?.presenter?.presentPostingItem(fromResponseModel: responseModel)
                        
                        return
                    }

                    let jsonMetadataString = ("{\"tags\":[\"" + (self?.tags)!
                                                .filter({ $0.isAddTag == false })
                                                .compactMap({ $0.title!.transliteration(forPermlink: false) }).joined(separator: ",") + "\"]")
                                                .replacingOccurrences(of: ",", with: "\",\"") + ",\"app\":\"golos.io/0.1\",\"format\":\"markdown\"}"
                    
//                    Logger.log(message: "\njsonMetadataString:\n\t\(jsonMetadataString!)", event: .debug)
                    
                    // Create Post with transliteration
                    let newPost = RequestParameterAPI.Comment(parentAuthor:       "",
                                                              parentPermlink:     (self?.tags?.first?.title ?? "").transliteration(forPermlink: true),
                                                              author:             User.current!.nickName,
                                                              title:              self?.commentTitle ?? "",
                                                              body:               self?.commentBody ?? "",
                                                              jsonMetadata:       jsonMetadataString,
                                                              needTiming:         errorAPI.caseInfo.message.contains("timing"),
                                                              attachments:        self?.attachments)
                    
                    let operationAPIType = OperationAPIType.createPost(operations: [newPost])
                    
                    // Run API
                    self?.runRequest(withOperationAPIType: operationAPIType)
                })
                
            // .createComment & createCommentReply:
            default:
                let jsonMetadataString = ("{\"tags\":[\"" + (self?.commentParentTag ?? "test") + "\"]")
                                            .replacingOccurrences(of: ",", with: "\",\"") + ",\"app\":\"golos.io/0.1\",\"format\":\"markdown\"}"
                
//                Logger.log(message: "\njsonMetadataString:\n\t\(jsonMetadataString!)", event: .debug)
                
                // Create Comment with transliteration
                let newCommentOrReply = RequestParameterAPI.Comment(parentAuthor:       self?.commentParentAuthor ?? "",
                                                                    parentPermlink:     self?.commentParentPermlink ?? "",
                                                                    author:             (User.current?.nickName)!,
                                                                    title:              "",
                                                                    body:               self?.commentBody ?? "",
                                                                    jsonMetadata:       jsonMetadataString,
                                                                    needTiming:         true,
                                                                    attachments:        self?.attachments)
                
                let operationAPIType = OperationAPIType.comment(fields: newCommentOrReply)
                
                // Run API
                self?.runRequest(withOperationAPIType: operationAPIType)
            }
        })
    }
    
    private func runRequest(withOperationAPIType operationAPIType: OperationAPIType) {
        let postRequestQueue = DispatchQueue.global(qos: .background)
        
        // Run queue in Async Thread
        postRequestQueue.async {
            broadcast.executePOST(requestByOperationAPIType:    operationAPIType,
                                  userNickName:                 User.current!.nickName,
                                  onResult:                     { [weak self] responseAPIResult in
                                    var errorAPI: ErrorAPI?
                                    
                                    if let error = (responseAPIResult as! ResponseAPIBlockchainPostResult).error {
                                        errorAPI = ErrorAPI.requestFailed(message: error.message)
                                    }
                                    
                                    let responseModel = PostCreateModels.Item.ResponseModel(errorAPI: errorAPI)
                                    self?.presenter?.presentPostingItem(fromResponseModel: responseModel)
                },
                                  onError: { [weak self] errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    let responseModel = PostCreateModels.Item.ResponseModel(errorAPI: errorAPI)
                                    self?.presenter?.presentPostingItem(fromResponseModel: responseModel)
            })
        }
    }
}
