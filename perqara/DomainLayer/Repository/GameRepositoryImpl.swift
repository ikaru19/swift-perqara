//
//  GameRepositoryImpl.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift

class GameRepositoryImpl: GameRepository {
    private var getGameDetailDataSource: GetGameDetailDataSource
    private var getGameListDataSource: GetGameListDataSource
    private var localGameDataSource: GameLocalDataSource
    private var disposeBag = DisposeBag()
    
    init(
        getGameDetailDataSource: GetGameDetailDataSource,
        getGameListDataSource: GetGameListDataSource,
        localGameDataSource: GameLocalDataSource
    ) {
        self.getGameDetailDataSource = getGameDetailDataSource
        self.getGameListDataSource = getGameListDataSource
        self.localGameDataSource = localGameDataSource
    }

    func getGame(byId: String) -> Single<Domain.GameEntity> {
        Single.create(subscribe: { [self] observer in
            getGameDetailDataSource
                .getGameDetailDataSource(id: byId)
                    .subscribe(
                            onSuccess: { [weak self] data in
                                guard let self = self else {
                                    observer(.error(DomainError(reason: .selfIsNull, line: 37)))
                                    return
                                }
                                if let data = data {
                                    let processedData = self.rawDataMapper(data: data)
                                    observer(.success(processedData))
                                } else {
                                    observer(.error(DomainError(reason: .noData, line: 37)))
                                }
                            },
                            onError: { error in
                                observer(.error(error))
                            }
                    ).disposed(by: disposeBag)
            return Disposables.create()
        })
    }
    
    func getGameList(page: Int, search: String?) -> Single<[Domain.GameEntity]> {
        Single.create(subscribe: { [self] observer in
            getGameListDataSource
                .getGameListDataSource(page: page, search: search)
                    .subscribe(
                            onSuccess: { [weak self] data in
                                var finalData : [Domain.GameEntity] = []
                                let processedData = self?.rawDataMapper(datas: data)
                                finalData.append(contentsOf: processedData ?? [])
                                observer(.success(finalData))
                            },
                            onError: { error in
                                observer(.error(error))
                            }
                    ).disposed(by: disposeBag)
            return Disposables.create()
        })
    }
    
    
    // MARK: LOCAL
    func insertToLocal(game: Domain.GameEntity) -> RxSwift.Completable {
        let game = rawDataMapper(data: game)
        return localGameDataSource.insertGame(game: game)
    }
    
    func getLocalGame(byId: String) ->  RxSwift.Single<Domain.GameEntity?> {
        Single.create(subscribe: { [self] observer in
            localGameDataSource
                .fetchBy(id: byId)
                    .subscribe(
                            onSuccess: { [weak self] data in
                                if let self = self,
                                   let data = data.first {
                                    let finalData = self.rawDataMapper(data: data)
                                    observer(.success(finalData))
                                }
                                observer(.success(nil))
                            },
                            onError: { error in
                                observer(.error(error))
                            }
                    ).disposed(by: disposeBag)
            return Disposables.create()
        })
    }
    
    func getLocalGame() -> RxSwift.Single<[Domain.GameEntity]> {
        Single.create(subscribe: { [self] observer in
            localGameDataSource
                .fetchAll()
                .subscribe(
                    onSuccess: { [weak self] data in
                        if let self = self {
                            var finalData = self.rawDataMapper(datas: data)
                            observer(.success(finalData))
                        }
                        observer(.error(DomainError(reason: .noData, line: 89)))
                    },
                    onError: { error in
                        observer(.error(error))
                        
                    }
                ).disposed(by: disposeBag)
            return Disposables.create()
        })
    }
    
    func deleteLocalGame(byId: String) -> RxSwift.Completable {
        localGameDataSource.deleteBy(id: byId)
    }
    
}

extension GameRepositoryImpl {
    private func rawDataMapper(data: Data.DataGameEntity) -> Domain.GameEntity {
        return Domain.GameEntity(
            id: String(data.id ?? -1),
            name: data.name ?? "-",
            released: data.released ?? "-",
            backgroundImage: data.backgroundImage ?? "-",
            rating: String(data.rating ?? 0.0),
            description: data.description ?? "-",
            suggestionsCount: String(data.suggestionsCount ?? 0),
            developer: data.developer.map({ $0.name ?? "-" }).joined(separator:","),
            isFavorite: false
        )
    }
    
    private func rawDataMapper(datas: [Data.DataGameEntity]) -> [Domain.GameEntity] {
        var finalData : [Domain.GameEntity] = []
        for data in datas {
            if let id = data.id {
                let rawData = Domain.GameEntity(
                    id: String(data.id ?? -1),
                    name: data.name ?? "-",
                    released: data.released ?? "-",
                    backgroundImage: data.backgroundImage ?? "-",
                    rating: String(data.rating ?? 0.0),
                    description: data.description ?? "-",
                    suggestionsCount: String(data.suggestionsCount ?? 0),
                    developer: data.developer.map({ $0.name ?? "-" }).joined(separator:","),
                    isFavorite: false
                )
                finalData.append(rawData)
            }
        }
        return finalData
    }
    
    private func rawDataMapper(datas: [LocalGameEntity]) -> [Domain.GameEntity] {
        var finalData : [Domain.GameEntity] = []
        for data in datas {
            let rawData = Domain.GameEntity(
                id: data.id,
                name: data.name,
                released: data.released,
                backgroundImage: data.backgroundImage,
                rating: data.rating,
                description: data.description,
                suggestionsCount: data.suggestionsCount,
                developer: data.developer,
                isFavorite: true
            )
            finalData.append(rawData)
        }
        return finalData
    }
    
    private func rawDataMapper(data: LocalGameEntity) -> Domain.GameEntity {
        return Domain.GameEntity(
            id: data.id,
            name: data.name,
            released: data.released,
            backgroundImage: data.backgroundImage,
            rating: data.rating,
            description: data.descriptionData,
            suggestionsCount: data.suggestionsCount,
            developer: data.developer,
            isFavorite: true
        )
    }
    
    private func rawDataMapper(data: Domain.GameEntity) -> LocalGameEntity {
        return LocalGameEntity(
            id: data.id,
            name: data.name,
            released: data.released,
            backgroundImage: data.backgroundImage,
            rating: data.rating,
            descriptionData: data.description,
            suggestionsCount: data.suggestionsCount,
            developer: data.developer
        )
    }
}
