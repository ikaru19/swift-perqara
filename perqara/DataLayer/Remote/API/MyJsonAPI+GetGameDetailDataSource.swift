//
//  MyJsonAPI+GetGameDetailDataSource.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetGameDetailDataSource {
    func getGameDetailDataSource(id: String) -> Single<Data.DataGameEntity?> {
        let endpoint = "games/\(id)"
        return Single.create(subscribe: { [weak self] observer in
            self?
                .jsonRequestService
                .get(
                    to: endpoint,
                    param: [:],
                    header: [:]
                )
                .subscribe(
                    onNext: { [weak self] data in
                        var gameData : Data.DataGameEntity?
                        if let dict = data as? [String: Any] {
                            gameData = self?.rawDataMapper(dictionary: dict)
                        }
                        observer(.success(gameData))
                        
                    },
                    onError: { [weak self] error in
                        observer(.error(error))
                    }
                )
            return Disposables.create()
        })
    }
    
    
}

private extension MyJsonAPI {
    func rawDataMapper(dictionary: [String:Any]) -> Data.DataGameEntity? {
        var data: Data.DataGameEntity?
        var developer: [Data.DataDeveloperEntity] = []
        if let rawDev: [[String: Any]] = dictionary["developers"] as? [[String : Any]] {
             for processed in rawDev {
                 let data = Data.DataDeveloperEntity(
                        id: processed["id"] as? Int,
                        name: processed["name"] as? String,
                        backgroundImage: processed["image_background"] as? String
                    )
                developer.append(data)
             }
        }
        data = Data.DataGameEntity(
            id: dictionary["id"] as? Int,
            name: dictionary["name"] as? String,
            released: dictionary["released"] as? String,
            backgroundImage: dictionary["background_image"] as? String,
            rating: dictionary["rating"] as? Double,
            description: dictionary["description"] as? String,
            suggestionsCount: dictionary["suggestions_countf"] as? Int,
            developer: developer
        )
        return data
    }
}
