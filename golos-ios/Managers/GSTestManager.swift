//
//  GSTestManager.swift
//  Golos
//
//  Created by msm72 on 26.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//

import GoloSwift
import Foundation

class GSTestManager {
    // MARK: - Custom Functions
    static func createTestPost() {
        let comment                 =   RequestParameterAPI.Comment(parentAuthor:       "",
                                                                    parentPermlink:     "test",
                                                                    author:             "msm72",
                                                                    title:              "Test Post 2",
                                                                    body:               "Amndmnasmdn asmdn masndmasnd",
                                                                    jsonMetadata:       "")
        
        //        let vote                    =   RequestParameterAPI.Vote(voter:         "xeroc",
        //                                                                 author:        "xeroc",
        //                                                                 permlink:      "piston",
        //                                                                 weight:        10000)
        
        let operationAPIType        =   OperationAPIType.createPost(operations: [comment])
        
        
        // API `Create new post`
        broadcast.executePOST(requestByOperationAPIType:    operationAPIType,
                              userName:                     User.current!.name,
                              onResult:                 { /*[weak self]*/ responseAPIResult in
                                if let error = (responseAPIResult as! ResponseAPIBlockchainPostResult).error {
                                    Logger.log(message: "nresponse API Error = \(error.message)\n", event: .error)
                                }
        },
                              onError: { errorAPI in
                                Logger.log(message: "nresponse API Error = \(errorAPI.caseInfo.message)\n", event: .error)
        })
    }
}
