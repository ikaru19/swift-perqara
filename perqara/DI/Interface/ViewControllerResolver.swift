//
//  ViewControllerResolver.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import Cleanse

protocol ViewControllerResolver: AnyObject {
    func instantiateHomeViewController() -> Provider<Presentation.UiKit.HomeViewController>
    func instantiateGameDetailController() -> Provider<Presentation.UiKit.GameDetailViewController>
}
