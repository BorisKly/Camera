//
//  CameraDeviceVC+PhotoCapture .swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//

import AVFoundation
import UIKit

extension CameraDeviceViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
      
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        guard let image = UIImage(data: data) else {
            return
        }
        guard let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("capturedPhoto\(Date().formatTo(style: .auth)).jpg") else {
            return
        }
        do {
            try data.write(to: fileURL)
            print("photo saved \(fileURL.path)")
        } catch {
            print("error \(error)")
        }
    }
}
