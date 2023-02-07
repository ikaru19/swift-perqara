//
//  HomeViewModelImpl.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift
import RxRelay

class HomeViewModelImpl: HomeViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _gameLists: PublishRelay<[Domain.GameEntity]> = PublishRelay()
    private var disposeBag = DisposeBag()
    
    var errors: Observable<Error> {
        _errors.asObservable()
    }
    
    var gameLists: Observable<[Domain.GameEntity]> {
        _gameLists.asObservable()
    }
    
    var lastPage: Int?
    var gameRepository: GameRepository
    
    init(gameRepository: GameRepository) {
        self.gameRepository = gameRepository
    }

    func getGameList(page: Int, search: String?) {
        gameRepository
            .getGameList(page: page, search: search)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?._gameLists.accept(data)
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
}
