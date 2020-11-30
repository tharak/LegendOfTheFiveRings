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
        XCTAssertNotNil(self.model.getCharacters())
        XCTAssertNotNil(self.model.getCharacters().count == 0)
    }
    
    func testCreateCharacters() {
        XCTAssert(model.getCharacters().isEmpty)
        XCTAssert(model.getCharacters().count == 0)
        let char = self.model.create(name: "Wilson", xp: 45)
        XCTAssert(char.id == model.getCharacters().last?.id)
        XCTAssert(model.getCharacters().count == 1)
    }
    
    func testUpdateCharacter() {
        let character = self.model.create(name: "Wilson", xp: 45)
        character.xp = 12
        let updated = model.update(character: character)
        XCTAssertTrue(character.id == updated.id)
        XCTAssertTrue(character.xp == updated.xp)
    }

    func testDeleteCharacters() {
        XCTAssert(model.getCharacters().count == 0)
        let char = self.model.create(name: "Wilson Dead", xp: 45)
        XCTAssert(model.getCharacters().count == 1)
        model.delete(character: char)
        XCTAssert(model.getCharacters().count ==  0)
    }
}
