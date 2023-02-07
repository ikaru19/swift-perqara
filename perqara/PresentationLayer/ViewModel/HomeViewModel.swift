//
//  HomeViewModel.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RxSwift

protocol HomeViewModel: AnyObject {
    var errors: Observable<Error> { get }
    var gameLists: Observable<[Domain.GameEntity]> { get }
    var lastPage: Int? { get set }
    
    func getGameList(page: Int, search: String?)
}
