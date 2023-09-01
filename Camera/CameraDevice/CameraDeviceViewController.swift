//
//  CameraDeviceViewController.swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//

import AVFoundation
import UIKit

protocol CameraDeviceViewControllerDelegate: AnyObject {
    func shutterButtonPressed()
    func dismissCamera()
}

class CameraDeviceViewController: UIViewController {
           
    weak var delegateReloadCollection: ReloadCollectionDelegate?
    
    public var camera: CameraService {
        resolve(CameraService.self)
    }
            
    var currentPhotoSettings: AVCapturePhotoSettings?
    
    private var mainView: CameraDeviceView? {
        return self.view as? CameraDeviceView
    }
    
    override func loadView() {
        let mainView = CameraDeviceView(frame: CGRect.zero)
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        mainView?.delegate = self
        camera.checkCameraPermissions()
        mainView?.previewLayer.session = camera.session
    }
}

extension CameraDeviceViewController: CameraDeviceViewControllerDelegate {
    
    func dismissCamera() {
        self.dismiss(animated: true) {
        }
    }
    
    func shutterButtonPressed() {
        let settings = AVCapturePhotoSettings()
        currentPhotoSettings = settings
        camera.output.capturePhoto(with: settings,
                                   delegate: self)
    }
}

