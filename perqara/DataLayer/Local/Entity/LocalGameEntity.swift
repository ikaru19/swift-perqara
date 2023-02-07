//
//  LocalGameEntity.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 07/02/23.
//

import Foundation
import RealmSwift

class LocalGameEntity: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var released: String = ""
    @objc dynamic var backgroundImage: String = ""
    @objc dynamic var rating: String = ""
    @objc dynamic var descriptionData: String = ""
    @objc dynamic var suggestionsCount: String = ""
    @objc dynamic var developer: String = ""

    convenience init(
            id: String,
            name: String,
            released: String,
            backgroundImage: String,
            rating: String,
            descriptionData: String,
            suggestionsCount: String,
            developer: String
    ) {
        self.init()
        self.id = id
        self.name = name
        self.released = released
        self.backgroundImage = backgroundImage
        self.rating = rating
        self.descriptionData = descriptionData
        self.suggestionsCount = suggestionsCount
        self.developer = developer
    }

    override static func primaryKey() -> String? {
        "id"
    }
}
