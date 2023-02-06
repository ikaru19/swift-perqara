//
//  MainTabViewController.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import UIKit

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class MainTabViewController: UITabBarController {
        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            initDesign()
            initViews()
        }
        
        func refreshTabItem() {
            self.viewControllers = [createHomeViewController(), createFavoriteViewController()]
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            refreshTabItem()
        }
    }
}

// MARK: DESIGN
private extension Presentation.UiKit.MainTabViewController {
    private func initDesign() {
        initTabBarContent()
    }
    
    private func initTabBarContent() {
    }
    
    private func initViews() {
        // define base color
        view.backgroundColor = .white

        refreshTabItem()

        // Update tab bar property
        tabBar.isTranslucent = false
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .lightGray.withAlphaComponent(0.1)
    }
}

// MARK: DESIGN
private extension Presentation.UiKit.MainTabViewController {
    func createHomeViewController() -> UIViewController {
        // Create Tab one
        let vc = Presentation.UiKit.HomeViewController(nibName: nil, bundle: nil)
        return createNavController(
                for: vc,
                title: "Home",
                navigationTitle: "Games For You",
                image: UIImage(systemName: "house"),
                selectedImage:UIImage(systemName: "house.fill")
        )
    }
    
    func createFavoriteViewController() -> UIViewController {
        // Create Tab one
        let vc = Presentation.UiKit.FavoriteViewController(nibName: nil, bundle: nil)
        return createNavController(
                for: vc,
                title: "Favorite",
                navigationTitle: "Favorite Games",
                image: UIImage(systemName: "heart"),
                selectedImage:UIImage(systemName: "heart.fill")
        )
    }
    
    private func createNavController(
            for rootViewController: UIViewController,
            title: String,
            navigationTitle: String,
            image: UIImage?,
            selectedImage: UIImage?
    ) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.tabBarItem.selectedImage = selectedImage
        rootViewController.navigationItem.title = navigationTitle
        return navController
    }

}
