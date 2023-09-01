//
//  CollectionViewController.swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//

import UIKit

protocol ReloadCollectionDelegate: AnyObject {
    func reloadCollection()
}

class PhotosCollectionViewController: UICollectionViewController {
    
    private let cameraDeviceVC = CameraDeviceViewController()
    
    private var myPhotos = [(URL, UIImage)]()
    
    private var selectedImages = [(URL, UIImage)]()

    private let itemsPerRow: CGFloat = 2
    
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
 
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    private lazy var addBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonTapped))
    }()
    
    private lazy var  photoActionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(photoBarButtonTapped))
    }()
    
    private lazy var trashBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped))
    }()
    
    private lazy var actionBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionBarButtonTapped))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = Colors.backgroundBase

        cameraDeviceVC.delegateReloadCollection = self
        
        updateNavButtonsState()
        loadPhotosFromFileManager()
        setupNavigationBar()
        setupCollectionView()
   

    }
    
    private func updateNavButtonsState() {
        addBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        trashBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
        actionBarButtonItem.isEnabled = numberOfSelectedPhotos > 0
    }
    
    private func refresh() {
        self.selectedImages.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        self.collectionView.reloadData()
        updateNavButtonsState()
    }
    
    private func loadPhotosFromFileManager() {
        
        let fileManager = FileManager.default
        
        if let photosDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: photosDirectory, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    if let image = UIImage(contentsOfFile: fileURL.path) {
                        myPhotos.append((fileURL, image))
                    }
                }
            }
            catch {
                print("error getting a list of files \(error)")
            }
        }
    }
  
    // MARK:- Setup UI Elements
        
        private func setupCollectionView() {
        collectionView.register(PhotosCell.self, forCellWithReuseIdentifier: PhotosCell.reuseId)
        collectionView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "MY PHOTOS"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.textColor = Colors.primaryColor
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        
        navigationItem.rightBarButtonItems = [photoActionBarButtonItem,                                          actionBarButtonItem,
                                              addBarButtonItem,
                                              trashBarButtonItem]
    }
    
    // MARK: - NavigationItems Action

    @objc private func addBarButtonTapped(){
        print(#function)
    }
    
    @objc private func photoBarButtonTapped(){
        print(#function)
        present(cameraDeviceVC, animated: true)
    }
    
    @objc private func trashBarButtonTapped(){
      
        guard let fileURL = selectedImages.first?.0 else { return }
        
        let alertController = UIAlertController(title: "Photo delete", message: "Are you shure?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("file removed successfully ")
                if let index = self?.myPhotos.firstIndex(where: { (url, im) in
                    url == fileURL
                }) {
                    self?.myPhotos.remove(at: index)
                    self?.refresh()
                }
            } catch {
                print("Error removing file")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        
    }
    
    @objc private func actionBarButtonTapped(sender: UIBarButtonItem){
        print(#function)
        
        let shareController = UIActivityViewController(activityItems: selectedImages, applicationActivities: nil)
        shareController.completionWithItemsHandler = {
            _, bool, _, _ in
            if bool {
                self.refresh()
            }
        }
        
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true)
    }
    
    // MARK: UICollectionViewDataSource and UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCell.reuseId, for: indexPath) as! PhotosCell
        cell.photoImageView.image = myPhotos[indexPath.item].1
        cell.fileURL = myPhotos[indexPath.item].0
        cell.backgroundColor = .systemGreen
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image,
              let fileUrl = cell.fileURL else {
            return
        }
        selectedImages.append((fileUrl, image))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavButtonsState()
        let cell = collectionView.cellForItem(at: indexPath) as! PhotosCell
        guard let image = cell.photoImageView.image,
              let fileURL = cell.fileURL else {
            return
        }
        
        if let index = selectedImages.firstIndex(where: { (url, im ) in
            im == image
        }) {
            selectedImages.remove(at: index)
        }
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
//
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInserts.left * (itemsPerRow + 1)
        let availiableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availiableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sectionInserts.left
    }
}


