//
//  QRScannerViewController.swift
//  golos-ios
//
//  Created by Grigory Serebryanyy on 14/01/2018.
//  Copyright © 2018 golos. All rights reserved.
//

import UIKit
import AVFoundation

private let qrCodeNotFoundString = "QR код не обнаружен"

class QRScannerViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    // MARK: Camera properties
    var captureSession = AVCaptureSession()
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    
    // MARK: Delegate
    weak var delegate: QRScannerViewControllerDelegate?
    
   
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        startScanning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopScanning()
    }
    
    
    // MARK: Setup UI
    private func setupUI() {
        title = "QR сканнер"
        
        let closeButton = UIBarButtonItem(title: "Отмена",
                                          style: .done,
                                          target: self,
                                          action: #selector(didPressCancelButton))
        navigationItem.leftBarButtonItem = closeButton
        
        statusLabel.text = qrCodeNotFoundString
    }
    
    
    // MARK: View layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer?.frame = cameraView.bounds
    }
    
    
    // MARK: Camera
    private func startScanning() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                                      mediaType: AVMediaType.video,
                                                                      position: .back)
        guard let captureDevice = deviceDiscoverySession.devices.first else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [.qr]
            
        } catch {
            print(error)
            return
        }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        cameraView.layer.addSublayer(videoPreviewLayer!)
        
        captureSession.startRunning()
        
        qrCodeFrameView = UIView()
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
    
    private func stopScanning() {
        captureSession.stopRunning()
    }
    
    private func didScanQRCode(code: String) {
        delegate?.didScanQRCode(with: code)
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: Actions
    @objc
    func didPressCancelButton() {
        dismiss(animated: true, completion: nil)
    }
}

extension QRScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            statusLabel.text = qrCodeNotFoundString
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard metadataObj.type == .qr else {
            return
        }
        
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrCodeFrameView?.frame = barCodeObject!.bounds
        
        guard let stringValue = metadataObj.stringValue else {
            statusLabel.text = "QR код не содержит данных"
            return
        }
        
        didScanQRCode(code: stringValue)
    }
}
