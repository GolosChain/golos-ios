//
//  ScannerShowViewController.swift
//  golos-ios
//
//  Created by msm72 on 02.07.2018.
//  Copyright (c) 2018 golos. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import GoloSwift
import AVFoundation

// MARK: - Input & Output protocols
class ScannerShowViewController: GSBaseViewController {
    // MARK: - Properties
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!

    var router: (NSObjectProtocol & ScannerShowRoutingLogic)?
    var completionDetectQRCode: ((String) -> Void)?
    
    
    // MARK: - Class Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    deinit {
        Logger.log(message: "Success", event: .severe)
    }
    
    
    // MARK: - Setup
    private func setup() {
        let viewController          =   self
        let router                  =   ScannerShowRouter()
        
        viewController.router       =   router
        router.viewController       =   viewController
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        title                               =   "QR сканер".localized()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.loadViewSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if captureSession?.isRunning == false {
            captureSession.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if captureSession?.isRunning == true {
            captureSession.stopRunning()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    // MARK: - Custom Functions
    private func loadViewSettings() {
        view.backgroundColor    =   UIColor.black
        captureSession          =   AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        }
        
        else {
            self.failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        }
        
        else {
            self.failed()
            return
        }
        
        previewLayer                =   AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame          =   view.layer.bounds
        previewLayer.videoGravity   =   .resizeAspectFill
        
        view.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    private func failed() {
        self.showAlertView(withTitle: "Error", andMessage: "Scanner device error", needCancel: false, completion: { [weak self] _ in
            self?.captureSession = nil
        })
    }
    
    private func found(code: String) {
        if code.hasPrefix("5") || code.hasPrefix("1") {
            self.showAlertView(withTitle: "Info", andMessage: "QR code is detected", needCancel: false, completion: { [weak self] _ in
                self?.completionDetectQRCode!(code)
                
                // Route
                self?.router?.routeToPreviousScene()
            })
        }
            
        else {
            self.showAlertView(withTitle: "Error", andMessage: "Scanner Key Code error", needCancel: false, completion: { [weak self] _ in
                self?.captureSession.startRunning()
            })
        }
    }
    
    
    // MARK: - Actions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        self.router?.routeToPreviousScene()
    }
}


// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension ScannerShowViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject    =   metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue       =   readableObject.stringValue else { return }
           
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            self.found(code: stringValue)
        }
    }
}
