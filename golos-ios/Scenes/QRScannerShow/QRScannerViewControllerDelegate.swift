//
//  QRScannerViewControllerDelegate.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import Foundation

protocol QRScannerViewControllerDelegate: class {
    func didScanQRCode(with value: String)
}
