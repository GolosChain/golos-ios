//
//  ArticleMediator.swift
//  Golos
//
//  Created by Grigory on 29/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit

class ArticleMediator: NSObject {
    private let articleTitleCellIdentifier = ArticleTitleTableViewCell.reuseIdentifier!
    private let articleImageCellIdentifier = ArticleImageTableViewCell.reuseIdentifier!
    private let articleTextCellIdentifier = ArticleTextTableViewCell.reuseIdentifier!
    private let articleFooterCellIdentifier = ArticleFooterTableViewCell.reuseIdentifier!
    
    weak var tableView: UITableView!
    
    
    //MARK: Configure
    func configure(tableView: UITableView) {
        self.tableView = tableView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.dataSource = self
        tableView.delegate = self
        
        registerCells()
    }
    
    func registerCells() {
        let nib = UINib(nibName: articleTitleCellIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: articleTitleCellIdentifier)
        let nib1 = UINib(nibName: articleImageCellIdentifier, bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: articleImageCellIdentifier)
        let nib2 = UINib(nibName: articleTextCellIdentifier, bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: articleTextCellIdentifier)
        let nib4 = UINib(nibName: articleFooterCellIdentifier, bundle: nil)
        tableView.register(nib4, forCellReuseIdentifier: articleFooterCellIdentifier)
    }
}


//MARK: UITableViewCellDataSource
extension ArticleMediator: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var resultCell: UITableViewCell!
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: articleTitleCellIdentifier) as! ArticleTitleTableViewCell
            resultCell = cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: articleImageCellIdentifier) as! ArticleImageTableViewCell
            resultCell = cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: articleTextCellIdentifier) as! ArticleTextTableViewCell
            resultCell = cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: articleImageCellIdentifier) as! ArticleImageTableViewCell
            resultCell = cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: articleTextCellIdentifier) as! ArticleTextTableViewCell
            resultCell = cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: articleFooterCellIdentifier) as! ArticleFooterTableViewCell
//            cell.tagsView.tagStringArray = ["Путешествия", "Творчество", "Блокчейн", "Жизнь", "Мираж"]
            resultCell = cell
        default:
            resultCell = UITableViewCell()
        }
        
        return resultCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
}


//MARK: UITableViewDelegate
extension ArticleMediator: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
