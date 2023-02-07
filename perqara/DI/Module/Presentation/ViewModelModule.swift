//
//  ViewModelModule.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import Cleanse

struct ViewModelModule: Module {
    static func configure(binder: UnscopedBinder) {
        binder.bind(HomeViewModel.self)
                .to(factory: HomeViewModelImpl.init)
        binder.bind(GameDetailViewModel.self)
                .to(factory: GameDetailViewModelImpl.init)
        binder.bind(FavoriteViewModel.self)
                .to(factory: FavoriteViewModelImpl.init)
    }
}
