//
//  MyJsonAPI+GameListDataSource.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

extension MyJsonAPI: GetGameListDataSource {
    func getGameListDataSource(page: Int, search: String?) -> Single<[Data.DataGameEntity]> {
        let endpoint = "games"
        let params : [String: Any?] = [
            "page": page,
            "page_size": 30,
            "search": search
        ]
        return Single.create(subscribe: { [weak self] observer in
            self?
                .jsonRequestService
                .get(
                    to: endpoint,
                    param: params.compactMapValues {
                        $0
                    },
                    header: [:]
                )
                .subscribe(
                    onNext: { [weak self] data in
                        var gameData : [Data.DataGameEntity] = []
                        if let dict = data as? [String: Any] {
                            let processedData = self?.rawDataMapper(dictionary: dict)
                            gameData.append(contentsOf: processedData ?? [])
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
    func rawDataMapper(dictionary: [String:Any]) -> [Data.DataGameEntity] {
        var games : [Data.DataGameEntity] = []
        if let results: [[String: Any]] = dictionary["results"] as? [[String : Any]] {
             for processed in results {
                 let data = Data.DataGameEntity(
                     id: processed["id"] as? Int,
                     name: processed["name"] as? String,
                     released: processed["released"] as? String,
                     backgroundImage: processed["background_image"] as? String,
                     rating: processed["rating"] as? Double
                 )
                games.append(data)
             }
        }
        return games
    }
}
