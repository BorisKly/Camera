//
//  CameraDeviceView.swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//

import UIKit
import AVFoundation

class CameraDeviceView: UIView {
    
    weak public var delegate: CameraDeviceViewControllerDelegate?
    
    private let backButton = UIButton()
    private let shutterButton = UIButton()
    public var previewLayer = AVCaptureVideoPreviewLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupPreviewLayer()
        setupShutterButton()
        setupBackButton()
        
    }
    
    private func setupPreviewLayer() {
        self.layer.addSublayer(previewLayer)
        previewLayer.frame = self.bounds
        previewLayer.backgroundColor = UIColor.systemBlue.cgColor
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    private func setupShutterButton() {
        self.addSubview(shutterButton)
        shutterButton.layer.cornerRadius = 50
        shutterButton.layer.borderWidth = 10
        shutterButton.layer.borderColor = UIColor.white.cgColor
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            shutterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20),
            shutterButton.widthAnchor.constraint(equalToConstant: 100),
            shutterButton.heightAnchor.constraint(equalToConstant: 100)])
        shutterButton.addTarget(self, action: #selector(didActionTakePhoto), for: .touchUpInside)
    }
    
    @objc func didActionTakePhoto() {
        delegate?.shutterButtonPressed()
    }
    
    private func setupBackButton() {
        self.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20) ,
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 50),
            backButton.heightAnchor.constraint(equalToConstant: 50)])
       
        let image = UIImage(systemName: "multiply")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        backButton.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: backButton.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: backButton.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: backButton.bottomAnchor),
            imageView.topAnchor.constraint(equalTo: backButton.topAnchor),
        ])
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
    }
    
    @objc func backAction() {
        delegate?.dismissCamera()
    
    }
}
