//
//  PhotosCollectionVC+reloadCollectionDelegate.swift
//  Camera
//
//  Created by Borys Klykavka on 01.09.2023.
//

import Foundation

extension PhotosCollectionViewController: ReloadCollectionDelegate {
    func reloadCollection() {
        print("reloadCollection!!!")
        collectionView.reloadData()
    }
}
