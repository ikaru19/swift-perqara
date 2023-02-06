//
//  DataModule.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import Cleanse

struct DataModule: Module {
    static func configure(binder: SingletonScope) {
        binder.include(module: NetworkingModule.self)
        binder.include(module: MyAPIModule.self)
    }
}
