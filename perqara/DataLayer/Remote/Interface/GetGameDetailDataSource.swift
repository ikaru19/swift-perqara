//
//  GetGameDetailDataSource.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import RxSwift
import Alamofire

protocol GetGameDetailDataSource: AnyObject {
    func getGameDetailDataSource(id: String) -> Single<Data.DataGameEntity?>
}
