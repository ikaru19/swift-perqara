//
//  GameRepository.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift

protocol GameRepository: AnyObject {
    func getGame(byId: String) -> Single<Domain.GameEntity>
    func getGameList(page: Int, search: String?) ->Single<[Domain.GameEntity]>
}
