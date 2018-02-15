//
//  String+Dictionary.swift
//  Golos
//
//  Created by Grigory on 15/02/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

extension String {
    func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            return json
        } catch {
            print(error.localizedDescription)
        }
        
        return nil
    }
}
