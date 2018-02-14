//
//  ProfilePresenter.swift
//  Golos
//
//  Created by Grigory Serebryanyy on 15/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

protocol ProfilePresenterProtocol: class {
    
}

protocol ProfileViewProtocol: class {
    func didLoadArticles()
    func didLoadProfileData()
    func didRefreshSuccess()
    func didChangedFeedTab(isForward: Bool, previousAmount: Int)
}

class ProfilePresenter: NSObject {
    // MARK: View
    weak var profileView: ProfileViewProtocol!
    
    override init() {
        super.init()
    }
    
}

extension ProfilePresenter: ProfilePresenterProtocol {
   
}
