//
//  HomeViewController.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import UIKit

// MARK: LIFECYCLE AND CALLBACK
extension Presentation.UiKit {
    class HomeViewController: UIViewController {

        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            initDesign()
        }
    }
}

// MARK: DESIGN
private extension Presentation.UiKit.HomeViewController {
    private func initDesign() {
        setupBaseView()
    }
    
    func setupBaseView() {
        view.backgroundColor = .red
    }
}
