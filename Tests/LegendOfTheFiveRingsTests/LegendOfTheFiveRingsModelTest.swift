//
//  File.swift
//  
//
//  Created by Tharak on 30/11/20.
//

import XCTest
@testable import LegendOfTheFiveRings

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

    func testBuyItem() {
        let xp = 45
        let cost = 3
        self.model.create(name: "Wilson", xp: xp)
        let character = self.model.characters.first!
        XCTAssertTrue(character.items.count == 0)
        model.buyItem(type: Item.ItemType.advantages, name: "Allies", points: cost, for: character)
        XCTAssertTrue(character.items.count == 1)
        XCTAssertTrue(character.xp == xp - cost)
        XCTAssertTrue(character.getItems()[0].name == "Allies")

        model.buyItem(type: Item.ItemType.advantages, name: "Allies2", points: cost, for: character)
        XCTAssertTrue(character.items.count == 2)
        XCTAssertTrue(character.xp == xp - cost - cost)
        XCTAssertTrue(character.getItems()[0].name == "Allies")
        XCTAssertTrue(character.getItems()[1].name == "Allies2")

        model.buyItem(type: Item.ItemType.disadvantages, name: "Enemies", points: cost, for: character)
        XCTAssertTrue(character.items.count == 3)
        XCTAssertTrue(character.xp == xp - cost - cost + cost)

        XCTAssertTrue(character.getItems()[0].name == "Allies")
        XCTAssertTrue(character.getItems()[1].name == "Allies2")
        XCTAssertTrue(character.getItems()[2].name == "Enemies")
    }

    func testCharacterCreation() {
        self.model.create(name: "Wilson", xp: 45)
        let character = self.model.characters.first!

        XCTAssertTrue(character.name == "Wilson")
        XCTAssertTrue(character.honor == 0)
        XCTAssertTrue(character.status == 0)
        XCTAssertTrue(character.glory == 0)
        XCTAssertNil(character.clan())
        XCTAssertNil(character.family())
        XCTAssertTrue(character.schools().isEmpty)
        XCTAssertTrue(character.items.count == 0)
        for trait in TraitName.allCases {
            XCTAssertTrue(character.trait(name: trait) == 2)
        }
        for ring in RingName.allCases {
            XCTAssertTrue(character.ring(name: ring) == 2)
        }
        XCTAssertTrue(character.insight() == 100)
        XCTAssertTrue(character.rank() == 1)
        XCTAssertTrue(character.getItems().isEmpty)
    }

    func testCharacterBuyClan() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        self.model.pickClan(name: ClanName.crab.rawValue, for: character)
        XCTAssertTrue(self.model.characters.first!.items.count == 1)
        XCTAssertTrue(self.model.characters.first!.clan()?.name == ClanName.crab.rawValue)
        self.model.pickClan(name: ClanName.badger.rawValue, for: character)
        XCTAssertTrue(self.model.characters.first!.getItems(type: Item.ItemType.clans).count == 1)
        XCTAssertTrue(self.model.characters.first!.clan()?.name == ClanName.badger.rawValue)
    }
    
    func testCharacterBuyFamily() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        let families = Book().families
        let hida = families.first(where: {$0.name == "Hida"})!
        
        self.model.pickFamily(family: hida, for: character)
        XCTAssertTrue(character.items.count == 2)
        XCTAssertNotNil(character.family())
        XCTAssertTrue(character.family()?.name == "Hida")
        XCTAssertTrue(character.trait(name: TraitName.strength) == 3)
        
        let hiruma = families.first(where: {$0.name == "Hiruma"})!
        self.model.pickFamily(family: hiruma, for: character)
        XCTAssertTrue(character.items.count == 2)
        XCTAssertNotNil(character.family())
        XCTAssertTrue(character.family()?.name == "Hiruma")
        XCTAssertTrue(character.trait(name: TraitName.strength) == 2)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 3)
    }

    func testCharacterBuySchool() {
        let schools = Book().schools
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        self.model.pickSchool(school: schools.first!, for: character)
        XCTAssertTrue(character.schools().count == 1)
        XCTAssertTrue(character.schools().first?.name == schools.first!.name)
        self.model.pickSchool(school: schools.last!, for: character)
        XCTAssertTrue(character.schools().count == 1)
    }

    func testCharacterBuyTrait() {
        self.model.create(name: "Wilson", xp: 0)
        let character = self.model.characters.first!
        self.model.buyTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 3)
        assert(character.xp == -12)
        self.model.buyTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 4)
        assert(character.xp == -12-16)
        self.model.buyTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 5)
        assert(character.xp == -12-16-20)
        XCTAssertTrue(character.ring(name: RingName.fire) == 2)
        self.model.buyTrait(name: TraitName.intelligence, for: character)
        assert(character.xp == -12-16-20-12)
        XCTAssertTrue(character.trait(name: TraitName.intelligence) == 3)
        XCTAssertTrue(character.ring(name: RingName.fire) == 3)

        self.model.sellTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 4)
        assert(character.xp == -12-16-12, "\(character.xp)")
        XCTAssertTrue(character.ring(name: RingName.fire) == 3)
        self.model.sellTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 3)
        assert(character.xp == -12-12, "\(character.xp)")
        XCTAssertTrue(character.ring(name: RingName.fire) == 3)
        self.model.sellTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 2)
        assert(character.xp == -12, "\(character.xp)")
        XCTAssertTrue(character.ring(name: RingName.fire) == 2)
        self.model.sellTrait(name: TraitName.agility, for: character)
        XCTAssertTrue(character.trait(name: TraitName.agility) == 2)
        assert(character.xp == -12, "\(character.xp)")
        XCTAssertTrue(character.ring(name: RingName.fire) == 2)
    }

    func testWounds() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!

        XCTAssertTrue(character.woundPerLevel() == 4)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.healthy) == 10)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.nicked) == 14)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.grazed) == 18)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.hurt) == 22)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.injured) == 26)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.crippled) == 30)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.down) == 34)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.out) == 38)

        self.model.buyTrait(name: TraitName.stamina, for: character)
        self.model.buyTrait(name: TraitName.willpower, for: character)
        XCTAssertTrue(character.woundPerLevel() == 6)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.healthy) == 15)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.nicked) == 21)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.grazed) == 27)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.hurt) == 33)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.injured) == 39)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.crippled) == 45)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.down) == 51)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.out) == 57)

        self.model.buyTrait(name: TraitName.stamina, for: character)
        self.model.buyTrait(name: TraitName.willpower, for: character)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.healthy) == 20)
        XCTAssertTrue(character.woundPerLevel() == 8)

        self.model.buyTrait(name: TraitName.stamina, for: character)
        self.model.buyTrait(name: TraitName.willpower, for: character)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.healthy) == 25)
        XCTAssertTrue(character.woundPerLevel() == 10)
    }

    func testWoundPenalties() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.healthy) == 0)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.nicked) == 3)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.grazed) == 5)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.hurt) == 10)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.injured) == 15)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.crippled) == 20)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.down) == 40)
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.out) == 100)
    }
}
