//
//  DataGameEntity.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation

extension Data {
    struct DataGameEntity {
        var id: Int?
        var name: String?
        var released: String?
        var backgroundImage: String?
        var rating: Double?
        var description: String?
        var suggestionsCount: Int?
        var developer: [DataDeveloperEntity] = []
    }
}
