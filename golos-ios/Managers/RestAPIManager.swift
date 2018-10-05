//  RestAPIManager.swift
//  Golos
//
//  Created by msm72 on 12.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import CoreData
import GoloSwift
import Foundation

class RestAPIManager {
    // MARK: - Class Functions
    /// Posting image
    class func posting(_ image: UIImage, _ signature: String, completion: @escaping (String?) -> Void)  {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }

        let session             =   URLSession(configuration: .default)
        let requestURL          =   URL(string: String(format: "%@/%@/%@", imagesURL, User.current!.nickName, signature))!
        
        let request             =   NSMutableURLRequest(url: requestURL)
        request.httpMethod      =   "POST"
        
        let boundaryConstant    =   "----------------12345"
        let contentType         =   "multipart/form-data;boundary=" + boundaryConstant
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // Create upload data to send
        let uploadData = NSMutableData()
        
        // Add image
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"picture\"; filename=\"post-image-ios.png\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData)
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody = uploadData as Data
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
            guard error == nil else {
                completion(nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String: Any], let imageURL = json["url"] as? String {
                completion(imageURL)
            }
                
            else {
                completion(nil)
            }
        })
        
        task.resume()
    }
    
    
    /// Load list of Users
    class func loadUsersInfo(byNickNames nickNames: [String], completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_accounts'
        if isNetworkAvailable {
            let methodAPIType = MethodAPIType.getAccounts(nickNames: nickNames)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                        Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserResult).result, result.count > 0 else {
                                        completion(ErrorAPI.requestFailed(message: nickNames.count == 1 ? "User is not found" : "List of users is empty"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entities
                                    result.forEach({
                                        let userEntity = User.instance(byUserID: $0.id)
                                        userEntity.updateEntity(fromResponseAPI: $0)
                                    })
                                    
                                    completion(nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(nil)
        }
    }

    
    /// Load list of PostFeed
    class func loadPostsFeed(byMethodAPIType methodAPIType: MethodAPIType, andPostFeedType postFeedType: PostsFeedType, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_discussions_by_blog' & 'get_replies_by_last_update'
        if isNetworkAvailable {
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIPostsResult).result, result.count > 0 else {
                                        completion(nil)
                                        return
                                    }
                                    
                                    // CoreData: Update Post entities by type
                                    _ = result.map({ responseAPIFeed in
                                        switch postFeedType {
                                        // Reply
                                        case .reply:
                                            Reply.updateEntity(fromResponseAPI: responseAPIFeed)
                                            
                                        // Popular
                                        case .popular:
                                            Popular.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Actual
                                        case .actual:
                                            Actual.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // New
                                        case .new:
                                            New.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Promo
                                        case .promo:
                                            Promo.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Blog
                                        case .blog:
                                            Blog.updateEntity(fromResponseAPI: responseAPIFeed)

                                        // Current user Lenta (blogs)
                                        default:
                                            Lenta.updateEntity(fromResponseAPI: responseAPIFeed)
                                        }
                                    })
                                    
                                    // Load authors info
                                    loadUsersInfo(byNickNames: Array(Set(result.compactMap({ $0.author }))), completion: { errorAPI in
                                        completion(errorAPI)
                                    })
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
        
        // Offline mode
        else {
            completion(nil)
        }
    }
    
    
    /// Load modified Post
    class func loadModifiedPost(author: String, permlink: String, postType: PostsFeedType, completion: @escaping (NSManagedObject?) -> Void) {
        let content = RequestParameterAPI.Content(author: author, permlink: permlink, active_votes: 1_000)
        
        RestAPIManager.loadPost(byContent: content, andPostType: postType, completion: { errorAPI in
            guard errorAPI == nil else {
                completion(nil)
                return
            }
            
            guard let postEntity = CoreDataManager.instance.readEntity(withName:                  postType.caseTitle(),
                                                                       andPredicateParameters:    NSPredicate(format: "author == %@ AND permlink == %@", author, permlink)) else {
                                                                        completion(nil)
                                                                        return
            }
            
            completion(postEntity)
        })
    }

    
    /// Load selected Post
    class func loadPost(byContent content: RequestParameterAPI.Content, andPostType postType: PostsFeedType, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_content'
        if isNetworkAvailable {
            let methodAPIType = MethodAPIType.getContent(parameters: content)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIPostResult).result else {
                                        completion(ErrorAPI.requestFailed(message: (responseAPIResult as! ResponseAPIPostResult).error!.message))
                                        return
                                    }
                                    
                                    // CoreData: Update Post entity by type
                                    switch postType {
                                    // Reply
                                    case .reply:
                                        Reply.updateEntity(fromResponseAPI: result)
                                        
                                    // Popular
                                    case .popular:
                                        Popular.updateEntity(fromResponseAPI: result)
                                        
                                    // Actual
                                    case .actual:
                                        Actual.updateEntity(fromResponseAPI: result)
                                        
                                    // New
                                    case .new:
                                        New.updateEntity(fromResponseAPI: result)
                                        
                                    // Promo
                                    case .promo:
                                        Promo.updateEntity(fromResponseAPI: result)
                                        
                                    // Blog
                                    case .blog:
                                        Blog.updateEntity(fromResponseAPI: result)
                                        
                                    // Current user Lenta (blogs)
                                    default:
                                        Lenta.updateEntity(fromResponseAPI: result)
                                    }
                                    
                                    completion(nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(ErrorAPI.requestFailed(message: "No Internet Connection"))
        }
    }

    
    /// Load Comments list for selected Post
    class func loadPostComments(byContent content: RequestParameterAPI.Content, andPostType postType: PostsFeedType, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_all_content_replies'
        if isNetworkAvailable {
            let methodAPIType = MethodAPIType.getContentAllReplies(parameters: content)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIAllContentRepliesResult).result else {
                                        completion(ErrorAPI.requestFailed(message: (responseAPIResult as! ResponseAPIAllContentRepliesResult).error!.message))
                                        return
                                    }
                                    
                                    // CoreData: Update Comment entity
                                    result.forEach({ Comment.updateEntity(fromResponseAPI: $0) })
                                    
                                    completion(nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(ErrorAPI.requestFailed(message: "No Internet Connection"))
        }
    }


    /// Load User Follow counts
    class func loadUserFollowCounts(byNickName nickName: String, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_follow_count'
        if isNetworkAvailable {
            let methodAPIType = MethodAPIType.getUserFollowCounts(nickName: nickName)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserFollowCountsResult).result else {
                                        completion(ErrorAPI.requestFailed(message: "User follow counts are not found"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entity
                                    if let user = User.fetch(byNickName: nickName) {
                                        user.updateEntity(fromResponseAPI: result)
                                    }
                                    
                                    completion(nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(nil)
        }
    }


    /// Load Current User Followings list
    class func loadFollowingsList(byUserNickName userNickName: String, authorNickName: String, pagination: UInt, completion: @escaping (Bool, ErrorAPI?) -> Void) {
        // API 'get_following'
        if isNetworkAvailable {
            let methodAPIType = MethodAPIType.getUserFollowings(userNickName: userNickName, authorNickName: authorNickName, pagination: pagination)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserFollowingsResult).result, let postAuthorNickName = result.first?.following else {
                                        completion(false, ErrorAPI.requestFailed(message: "User followings are not found"))
                                        return
                                    }
                                    
                                    completion(authorNickName == postAuthorNickName, nil)
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(false, errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(false, nil)
        }
    }
    
    
    /// Load User Follow counts
    class func loadPostPermlink(byContent content: RequestParameterAPI.Content, completion: @escaping (ErrorAPI) -> Void) {
        // API 'get_content'
        if isNetworkAvailable {
            let methodAPIType = MethodAPIType.getContent(parameters: content)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
//                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    let error = (responseAPIResult as! ResponseAPIPostResult).error
                                    completion(ErrorAPI.requestFailed(message: error == nil ? "Permlink without timing" : "Permlink with timing"))
            },
                                 onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
            
        // Offline mode
        else {
            completion(ErrorAPI.requestFailed(message: "No Internet Connection"))
        }
    }
    
    
    /// Upvote
    class func vote(up: Bool, postShortInfo: PostShortInfo, completion: @escaping (ErrorAPI?) -> Void) {
        let vote    =   RequestParameterAPI.Vote(voter:         User.current!.nickName,
                                                 author:        postShortInfo.author ?? "XXX",
                                                 permlink:      postShortInfo.permlink ?? "XXX",
                                                 weight:        up ? 10_000 : 0)

        let operationAPIType = OperationAPIType.vote(fields: vote)
        
        // Run API
        let postRequestQueue = DispatchQueue.global(qos: .background)
        
        // Run queue in Async Thread
        postRequestQueue.async {
            broadcast.executePOST(requestByOperationAPIType:    operationAPIType,
                                  userNickName:                 User.current!.nickName,
                                  onResult:                     { responseAPIResult in
                                    var errorAPI: ErrorAPI?
                                    
                                    if let error = (responseAPIResult as! ResponseAPIBlockchainPostResult).error {
                                        errorAPI = ErrorAPI.requestFailed(message: error.message)
                                    }
                                    
                                    completion(errorAPI)
                },
                                  onError: { errorAPI in
                                    Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
                                    completion(errorAPI)
            })
        }
    }
}
