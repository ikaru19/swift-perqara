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
            .getLocalGame(byId: byId)
            .subscribe(
                onSuccess: { [weak self] data in
                    if let data = data {
                        self?._gameData.accept(data)
                    } else {
                        self?.getRemoteGame(byId: byId)
                    }
                },
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
    
    func getRemoteGame(byId: String) {
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
    
    func insetGameToLocal(game: Domain.GameEntity) {
        gameRepository
            .insertToLocal(game: game)
            .subscribe(
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
    
    func deletaLocalGame(byId: String) {
        gameRepository
            .deleteLocalGame(byId: byId)
            .subscribe(
                onError: { [weak self] error in
                    self?._errors.accept(error)
                }
            ).disposed(by: disposeBag)
    }
    
    
}
