//
//  GameDetailViewModel.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift

protocol GameDetailViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var gameData: Observable<Domain.GameEntity> { get }
    
    func getGameDetail(byId: String)
}
