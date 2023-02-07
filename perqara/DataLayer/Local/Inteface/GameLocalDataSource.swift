//
//  GameLocalDataSource.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift
import RealmSwift

protocol GameLocalDataSource: AnyObject {
    func insertGame(
        game: LocalGameEntity
    ) -> Completable

    func fetchBy(
        id: String
    ) -> Single<[LocalGameEntity]>
    
    func fetchAll() -> Single<[LocalGameEntity]>
    
    func deleteBy(
        id: String
    ) -> Completable
}
