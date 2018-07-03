//
//  User+CoreDataClass.swift
//  Golos
//
//  Created by msm72 on 03.07.2018.
//  Copyright © 2018 golos. All rights reserved.
//
//

import CoreData
import GoloSwift
import Foundation

@objc(User)
public class User: NSManagedObject {
    // MARK: - Properties
    class var current: User? {
        get {
            return (CoreDataManager.instance.readEntity(withName: "User", andPredicateParameters: nil)) as? User
        }
    }
    
    
    // MARK: - Class Initialization
    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Class Functions
    func updateEntity(fromJSON json: [String: Any]) {
        self.id                 =   json["id"] as! Int64
        self.name               =   json["name"] as! String
        self.post_count         =   json["post_count"] as! Int64
        self.json_metadata      =   json["json_metadata"] as? String
        
//        @NSManaged public var memo: UserSecretKey?
//        @NSManaged public var owner: UserSecretKey?
//        @NSManaged public var active: UserSecretKey?
//        @NSManaged public var posting: UserSecretKey?

//        self.addressLine2       =   json["AddressLine2"] as? String
//        self.adv                =   json["Adv"] as! String
//        self.cardCVV            =   json["CardCVV"] as? String
//        self.cardExpired     =   json["CardExpired"] as? String
//        self.cardNumber      =   json["CardNumber"] as? String
//        self.cityId          =   json["CityId"] as! String
//        self.clientId        =   json["ClientId"] as! Int16
//        self.email           =   json["Email"] as! String
//        self.firstName       =   json["FirstName"] as! String
//        self.lastName        =   json["LastName"] as! String
//        self.laundryId       =   json["LaundryId"] as! Int16
//        self.mobilePhone     =   json["MobilePhone"] as! String
//        self.postCode        =   json["PostCode"] as? String
        
        // Extensions
        self.save()
    }
}
