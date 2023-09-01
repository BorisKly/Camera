//
//  MainTabBarController.swift
//  Camera
//
//  Created by Borys Klykavka on 31.08.2023.
//


import UIKit
import AVFoundation

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        let photosVC = PhotosCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let favouritesVC = FavouritesCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        
        viewControllers = [
            generateNavigationController(rootViewController: photosVC, title: "Photos", image: UIImage(systemName: "photo.stack")!),
            
            generateNavigationController(rootViewController: favouritesVC, title: "Favourites", image: UIImage(systemName: "photo.on.rectangle.angled")!)
        ]
    }
    
    private func generateNavigationController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.image = image
        navigationVC.tabBarItem.title = title
        
        return navigationVC
    }
}
