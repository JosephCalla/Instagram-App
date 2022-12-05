//
//  CameraViewController.swift
//  Instagram-App
//
//  Created by Joseph Estanislao Calla Moreyra on 18/10/22.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    private var output = AVCapturePhotoOutput()
    private var captureSession: AVCaptureSession?
    private let previewLayer = AVCaptureVideoPreviewLayer()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = "Take Photo"
        setupNavBar()
        checkCameraPermission()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captureSession?.stopRunning()
        //
        //        if let session = captureSession, !session.isRunning {
        //            session.startRunning()
        //        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: view.width
        )
    }
    
    @objc func didTapClose() {
        tabBarController?.selectedIndex = 0
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
        
        //        navigationController?.navigationBar.setBackgroundImage(UIImage(),
        //                                                               for: UIBarMetrics.default)
        //        navigationController?.navigationController?.navigationBar.shadowImage = UIImage()
        //        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .notDetermined:
            // Request
            AVCaptureDevice.requestAccess(for: .video) { granted in
                guard granted else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.setUpCamera()
                }
            }
        case .restricted,.denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let captureSession = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch {
                print(error)
            }
            
            if captureSession.canAddOutput(output) {
                captureSession.addOutput(output)
            }
            
            // Layer
            previewLayer.session = captureSession
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
            
            captureSession.startRunning()
        }
    }
    
}
