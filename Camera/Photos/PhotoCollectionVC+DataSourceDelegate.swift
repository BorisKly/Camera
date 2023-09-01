//
//  PhotoCollectionVC+DataSourceDelegate.swift
//  Camera
//
//  Created by Borys Klykavka on 01.09.2023.
//

import UIKit

extension PhotosCollectionViewController {
    
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
