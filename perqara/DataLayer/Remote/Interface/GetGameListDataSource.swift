//
//  GetGameListDataSource.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import RxSwift
import Alamofire

protocol GetGameListDataSource: AnyObject {
    func getGameListDataSource(page: Int, search: String?) -> Single<[Data.DataGameEntity]>
}
