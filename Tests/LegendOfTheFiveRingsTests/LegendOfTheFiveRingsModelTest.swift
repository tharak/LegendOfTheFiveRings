//
//  File.swift
//  
//
//  Created by Tharak on 30/11/20.
//

import XCTest
import LegendOfTheFiveRings

final class LegendOfTheFiveRingsModelTests: XCTestCase {
    
    var model: LegendOfTheFiveRingsModel!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        model = LegendOfTheFiveRingsModel(coreDataStack: TestCoreDataStack())
    }

    override func tearDown() {
        super.tearDown()
        model = nil
    }

    func testGetCharacters() {
        XCTAssertNotNil(self.model.characters)
        XCTAssertNotNil(self.model.characters.count == 0)
    }
    
    func testCreateCharacters() {
        XCTAssert(model.characters.isEmpty)
        XCTAssert(model.characters.count == 0)
        self.model.create(name: "Wilson", xp: 45)
        XCTAssert(model.characters.count == 1)
    }
    
    func testUpdateCharacter() {
        self.model.create(name: "Wilson", xp: 45)
        let character = self.model.characters.first!
        character.xp = 12
        model.update(character: character)
        let updated = self.model.characters.first!
        XCTAssertTrue(character.id == updated.id)
        XCTAssertTrue(character.xp == updated.xp)
    }

    func testDeleteCharacters() {
        XCTAssert(model.characters.count == 0)
        self.model.create(name: "Wilson Dead", xp: 45)
        XCTAssert(model.characters.count == 1)
        model.delete(character: self.model.characters.first!)
        XCTAssert(model.characters.count ==  0)
    }
}
