//
//  GameDetailViewModelImpl.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift
import RxRelay

class GameDetailViewModelImpl: GameDetailViewModel {
    private var _errors: PublishRelay<Error> = PublishRelay()
    private var _gameData: PublishRelay<Domain.GameEntity> = PublishRelay()
    private var disposeBag = DisposeBag()
    
    var errors: Observable<Error> {
        _errors.asObservable()
    }
    
    var gameData: Observable<Domain.GameEntity> {
        _gameData.asObservable()
    }
    
    var gameRepository: GameRepository
    
    init(gameRepository: GameRepository) {
        self.gameRepository = gameRepository
    }

    func getGameDetail(byId: String) {
        gameRepository
            .getGame(byId: byId)
            .subscribe(
                onSuccess: { [weak self] data in
                    self?._gameData.accept(data)
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
}
