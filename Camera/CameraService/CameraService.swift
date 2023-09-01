//
//  CameraService.swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//

import Foundation
import AVFoundation

class CameraService {
    
    var session: AVCaptureSession?
    
    var output = AVCapturePhotoOutput()
    
    func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else {
                    return
                }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }
    
    private func setUpCamera() {
        let session = AVCaptureSession()

        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)

                if session.canAddInput(input) {
                    session.addInput(input)
                }

                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                DispatchQueue.global(qos: .background).async {
                    session.startRunning()
                }

                self.session = session

            } catch  {
                print(error)
            }
        }
    }
}
