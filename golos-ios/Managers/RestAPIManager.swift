//
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
        guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }

        let session             =   URLSession(configuration: .default)
        let requestURL          =   URL(string: String(format: "%@/%@/%@", imagesURL, User.current!.name, signature))!
        
        let request             =   NSMutableURLRequest(url: requestURL)
        request.httpMethod      =   "POST"
        
        let boundaryConstant    =   "----------------12345"
        let contentType         =   "multipart/form-data;boundary=" + boundaryConstant
        
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // Create upload data to send
        let uploadData          =   NSMutableData()
        
        // Add image
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"picture\"; filename=\"post-image-ios.png\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData)
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        request.httpBody        =   uploadData as Data
        
        let task                =   session.dataTask(with: request as URLRequest, completionHandler: { (data, _, error) -> Void in
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
    class func loadUsersInfo(byNames names: [String], completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_accounts'
        if isNetworkAvailable {
            let methodAPIType   =   MethodAPIType.getAccounts(names: names)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserResult).result, result.count > 0 else {
                                        completion(ErrorAPI.requestFailed(message: names.count == 1 ? "User is not found" : "List of users is empty"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entities
                                    _ = result.map({
                                        let userEntity = User.instance(byUserID: $0.id)
                                        userEntity.updateEntity(fromResponseAPI: $0)
                                        
                                        // Set User isAuthorized
                                        if names.count == 1 {
                                            User.fetch(byName: names.first!)?.setIsAuthorized(true)
                                        }
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
            print("methodAPIType = \(methodAPIType)")
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
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
                                    loadUsersInfo(byNames: Array(Set(result.compactMap({ $0.author }))), completion: { errorAPI in
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
    
    
    /// Load User Follow counts
    class func loadUserFollowCounts(byName name: String, completion: @escaping (ErrorAPI?) -> Void) {
        // API 'get_follow_count'
        if isNetworkAvailable {
            let methodAPIType   =   MethodAPIType.getUserFollowCounts(name: name)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
                                    guard let result = (responseAPIResult as! ResponseAPIUserFollowCountsResult).result else {
                                        completion(ErrorAPI.requestFailed(message: "User follow counts are not found"))
                                        return
                                    }
                                    
                                    // CoreData: Update User entity
                                    if let user = User.fetch(byName: name) {
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



    /// Load User Follow counts
    class func loadPostPermlink(byContent content: RequestParameterAPI.Content, completion: @escaping (ErrorAPI) -> Void) {
        // API 'get_content'
        if isNetworkAvailable {
            let methodAPIType   =   MethodAPIType.getContent(parameters: content)
            
            broadcast.executeGET(byMethodAPIType: methodAPIType,
                                 onResult: { responseAPIResult in
                                    Logger.log(message: "\nresponse API Result = \(responseAPIResult)\n", event: .debug)
                                    
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
}
