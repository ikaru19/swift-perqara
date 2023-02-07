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
    private var disposeBag = DisposeBag()
    
    init(
        getGameDetailDataSource: GetGameDetailDataSource,
        getGameListDataSource: GetGameListDataSource
    ) {
        self.getGameDetailDataSource = getGameDetailDataSource
        self.getGameListDataSource = getGameListDataSource
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
}

extension GameRepositoryImpl {
    private func rawDataMapper(data: Data.DataGameEntity) -> Domain.GameEntity {
        return Domain.GameEntity(
            id: data.id ?? -1,
            name: data.name ?? "-",
            released: data.released ?? "-",
            backgroundImage: data.backgroundImage ?? "-",
            rating: String(data.rating ?? 0.0),
            description: data.description ?? "-",
            suggestionsCount: String(data.suggestionsCount ?? 0),
            developer: data.developer.map({ $0.name ?? "-" })
        )
    }
    
    private func rawDataMapper(datas: [Data.DataGameEntity]) -> [Domain.GameEntity] {
        var finalData : [Domain.GameEntity] = []
        for data in datas {
            if let id = data.id {
                let rawData = Domain.GameEntity(
                    id: id,
                    name: data.name ?? "-",
                    released: data.released ?? "-",
                    backgroundImage: data.backgroundImage ?? "-",
                    rating: String(data.rating ?? 0.0),
                    description: data.description ?? "-",
                    suggestionsCount: String(data.suggestionsCount ?? 0),
                    developer: data.developer.map({ $0.name ?? "-" })
                )
                finalData.append(rawData)
            }
        }
        return finalData
    }
}
