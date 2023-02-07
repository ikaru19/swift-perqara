//
//  GameDomainEntity.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation

extension Domain {
    struct GameEntity {
        var id: Int
        var name: String
        var released: String
        var backgroundImage: String
        var rating: String
        var description: String
        var suggestionsCount: String
        var developer: [String] = []
    }
}
