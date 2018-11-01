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
    static func getGlobalProperties() {
        Broadcast.shared.getDynamicGlobalProperties(completion: { properties in
            if let globalProperties = properties {
                print("total_vesting_fund_steem = \(globalProperties.total_vesting_fund_steem), total_vesting_shares = \(globalProperties.total_vesting_shares)")
                
                RestAPIManager.loadUsersInfo(byNickNames: ["msm72"], completion: { errorAPI in
                    if let user = User.fetch(byNickName: "msm72") {
                        let vestingShares           =   Float((user.vestingShares.components(separatedBy: " ").first)!) ?? 0.0
                        let totalVestingShares      =   Float((globalProperties.total_vesting_shares.components(separatedBy: " ").first)!) ?? 0.0
                        let totalVestingFundSteem   =   Float((globalProperties.total_vesting_fund_steem.components(separatedBy: " ").first)!) ?? 0.0
                        
                        let result  =   totalVestingFundSteem * (vestingShares / totalVestingShares)
                        print("result = \(result)")
                    }
                })
            }
        })
    }
    
    static func createTestPost() {
        let comment                 =   RequestParameterAPI.Comment(parentAuthor:       "",
                                                                    parentPermlink:     "test",
                                                                    author:             "msm72",
                                                                    title:              "Test Post 2",
                                                                    body:               "Amndmnasmdn asmdn masndmasnd",
                                                                    jsonMetadata:       "",
                                                                    needTiming:         false)
        
        //        let vote                    =   RequestParameterAPI.Vote(voter:         "xeroc",
        //                                                                 author:        "xeroc",
        //                                                                 permlink:      "piston",
        //                                                                 weight:        10000)
        
        let operationAPIType        =   OperationAPIType.createPost(operations: [comment])
        
        
        // API `Create new post`
        broadcast.executePOST(requestByOperationAPIType:    operationAPIType,
                              userNickName:                 User.current!.nickName,
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
