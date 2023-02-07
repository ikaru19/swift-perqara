//
//  UIKitControllerModule.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import Cleanse

struct UIKitControllerModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(Presentation.UiKit.HomeViewController.self)
            .to {
                Presentation.UiKit.HomeViewController(nibName: nil, bundle: nil, viewModel: $0)
            }
        binder.bind(Presentation.UiKit.GameDetailViewController.self)
            .to {
                Presentation.UiKit.GameDetailViewController(nibName: nil, bundle: nil, viewModel: $0)
            }
    }
}
