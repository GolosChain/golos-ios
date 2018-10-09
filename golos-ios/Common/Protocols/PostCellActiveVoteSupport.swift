//
//  PostCellActiveVoteSupport.swift
//  Golos
//
//  Created by msm72 on 10/9/18.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import GoloSwift

protocol PostCellActiveVoteSupport {
    var activeVoteButton: UIButton! { get set }
    var activeVoteActivityIndicator: UIActivityIndicatorView! { get set }
}
