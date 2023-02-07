//
//  MainViewControllerResolver.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import Cleanse

class MainViewControllerResolver: ViewControllerResolver {

    var homeVcProvider: Provider<Presentation.UiKit.HomeViewController>
    var gameDetailVcProvider: Provider<Presentation.UiKit.GameDetailViewController>
    var favoriteVcProvider: Provider<Presentation.UiKit.FavoriteViewController>
    
    init(
        homeVcProvider: Provider<Presentation.UiKit.HomeViewController>,
        gameDetailVcProvider: Provider<Presentation.UiKit.GameDetailViewController>,
        favoriteVcProvider: Provider<Presentation.UiKit.FavoriteViewController>
    ) {
        self.homeVcProvider = homeVcProvider
        self.gameDetailVcProvider = gameDetailVcProvider
        self.favoriteVcProvider = favoriteVcProvider
    }

    func instantiateHomeViewController() -> Provider<Presentation.UiKit.HomeViewController> {
        homeVcProvider
    }
    
    func instantiateGameDetailController() -> Cleanse.Provider<Presentation.UiKit.GameDetailViewController> {
        gameDetailVcProvider
    }
    
    func instantiateFavoriteViewController() -> Cleanse.Provider<Presentation.UiKit.FavoriteViewController> {
        favoriteVcProvider
    }
}
