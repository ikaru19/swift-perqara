//
//  perqaraTests.swift
//  perqaraTests
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import XCTest
@testable import perqara

final class perqaraTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        test_entity_should_produce_game()
        test_game_should_produce_different_entity()
        test_entity_should_produce_data_game()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_entity_should_produce_game() {
        let entity = Domain.GameEntity(
            id: "1",
            name: "name",
            released: "released",
            backgroundImage: "backgorundImage",
            rating: "rating",
            description: "description",
            suggestionsCount: "suggestionsCount",
            developer: "developer",
            isFavorite: false
        )
        XCTAssert(entity != nil)
    }
    
    func test_game_should_produce_different_entity() {
        let entity = Domain.GameEntity(
            id: "1",
            name: "name",
            released: "released",
            backgroundImage: "backgorundImage",
            rating: "rating",
            description: "description",
            suggestionsCount: "suggestionsCount",
            developer: "developer",
            isFavorite: false
        )
        var entity2 = entity
        entity2.id = "2"
        XCTAssert(entity.id != entity2.id)
    }

    func test_entity_should_produce_data_game() {
        let developer = Data.DataDeveloperEntity(
            id: 1,
            name: "dev name",
            backgroundImage: "test"
        )
        let entity = Data.DataGameEntity(
            id: 1,
            name: "name",
            released: "released",
            backgroundImage: "backgroundImage",
            rating: 2.0,
            description: "descritpion",
            suggestionsCount: 4,
            developer: [developer]
        )
        XCTAssert(entity != nil)
    }
}
