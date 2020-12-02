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
        XCTAssertTrue(character.ancestors().count == 0)
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

    func testCharacterPickSchool() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        /*
         "outfit": "Light or Heavy Armor, Sturdy Clothing, Daisho, Heavy Weapon or Polearm, Traveling Pack, 3 Koku",
         */
        self.model.pickSchool(school: Book().schools[0], for: character)
        XCTAssertTrue(character.schools().count == 1)
        XCTAssertTrue(character.schools().first?.name == "Hida Bushi")
        XCTAssertTrue(character.getHonor() == 3.5)
        XCTAssertTrue(character.trait(name: TraitName.stamina) == 3)
        XCTAssertTrue(character.skills().count == 6)
        for skillName in ["Athletics", "Defense", "Heavy Weapons (Tetsubo)", "Intimidation", "Kenjutsu", "Lore: Shadowlands"] {
            XCTAssertTrue(character.skillRank(name: skillName) == 1, "\(skillName) is \(character.skillRank(name: skillName)) not 1")
        }
        /*
         "outfit": "Robes, Wakizashi, any one Knives, Scroll Satchel, Traveling Pack, 3 Koku",
         */
        self.model.pickSchool(school: Book().schools[1], for: character)
        XCTAssertTrue(character.schools().count == 1)
        XCTAssertTrue(character.schools().first?.name == "Kuni Shugenja")
        XCTAssertTrue(character.getHonor() == 2.5)
        XCTAssertTrue(character.trait(name: TraitName.stamina) == 2)
        XCTAssertTrue(character.trait(name: TraitName.willpower) == 3)
        XCTAssertTrue(character.skills().count == 6)
        for skillName in ["Calligraphy (Cipher)", "Defense", "Lore: Shadowlands", "Lore: Theology", "Spellcraft"] {
            if skillName == "Lore: Shadowlands" {
                XCTAssertTrue(character.skillRank(name: skillName) == 2, "\(skillName) is \(character.skillRank(name: skillName)) instead of 2")
            } else {
                XCTAssertTrue(character.skillRank(name: skillName) == 1)
            }
        }
        XCTAssertTrue(character.xp == 100)
    }

    func testCharacterBuyTrait() {
        self.model.create(name: "Wilson", xp: 0)
        let character = self.model.characters.first!
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.agility, for: character)
        for traitName in TraitName.allCases {
            if traitName == .agility {
                XCTAssertTrue(character.trait(name: traitName) == 3)
            } else {
                XCTAssertTrue(character.trait(name: traitName) == 2)
            }
        }
        assert(character.xp == -12)
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.agility, for: character)
        for traitName in TraitName.allCases {
            if traitName == .agility {
                XCTAssertTrue(character.trait(name: traitName) == 4)
            } else {
                XCTAssertTrue(character.trait(name: traitName) == 2)
            }
        }
        assert(character.xp == -12-16)
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.agility, for: character)
        for traitName in TraitName.allCases {
            if traitName == .agility {
                XCTAssertTrue(character.trait(name: traitName) == 5)
            } else {
                XCTAssertTrue(character.trait(name: traitName) == 2)
            }
        }
        assert(character.xp == -12-16-20)
        XCTAssertTrue(character.ring(name: RingName.fire) == 2)
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.intelligence, for: character)
        assert(character.xp == -12-16-20-12)
        for traitName in TraitName.allCases {
            if traitName == .agility {
                XCTAssertTrue(character.trait(name: traitName) == 5)
            } else if traitName == .intelligence {
                XCTAssertTrue(character.trait(name: traitName) == 3)
            } else {
                XCTAssertTrue(character.trait(name: traitName) == 2)
            }
        }
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

    func testBuySkill() {
        self.model.create(name: "Wilson", xp: 0)
        let character = self.model.characters.first!
        var expent = 0
        for i in 1..<11 {
            self.model.buySkill(type: Item.ItemType.skills, name: "skill", for: character)
            XCTAssertTrue(character.skillRank(name: "skill") == i)
            expent -= i
            XCTAssertTrue(character.xp == expent, "expected \(expent) got \(character.xp)")
        }
        XCTAssertTrue(character.skillRank(name: "skill") == 10)
        XCTAssertTrue(character.xp == -55)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 9)
        XCTAssertTrue(character.xp == -55+10, "got \(character.xp)")
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 8)
        XCTAssertTrue(character.xp == -55+10+9, "got \(character.xp)")
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 7)
        XCTAssertTrue(character.xp == -55+10+9+8, "got \(character.xp)")
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 6)
        XCTAssertTrue(character.xp == -55+10+9+8+7, "got \(character.xp)")
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 5)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6, "got \(character.xp)")
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 4)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 3)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 2)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4+3)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 1)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4+3+2)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 0)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4+3+2+1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 0)
        XCTAssertTrue(character.xp == 0)
        
        self.model.pickSchool(school: Book().schools[1], for: character)
        for skillName in ["Calligraphy (Cipher)", "Defense", "Lore: Shadowlands", "Lore: Theology", "Spellcraft"] {
            if skillName == "Lore: Shadowlands" {
                XCTAssertTrue(character.skillRank(name: skillName) == 2, "\(skillName) is \(character.skillRank(name: skillName)) instead of 2")
            } else {
                XCTAssertTrue(character.skillRank(name: skillName) == 1)
            }
        }
        self.model.buySkill(type: Item.ItemType.skills, name: "Lore: Shadowlands", for: character)
        XCTAssertTrue(character.skillRank(name: "Lore: Shadowlands") == 3)
        self.model.buySkill(type: Item.ItemType.skills, name: "Lore: Shadowlands", for: character)
        XCTAssertTrue(character.skillRank(name: "Lore: Shadowlands") == 4)

        self.model.buySkill(type: Item.ItemType.skills, name: "Defense", for: character)
        XCTAssertTrue(character.skillRank(name: "Defense") == 2)

        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        XCTAssertTrue(character.skillRank(name: "Lore: Shadowlands") == 3)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        XCTAssertTrue(character.skillRank(name: "Lore: Shadowlands") == 2)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        XCTAssertTrue(character.skillRank(name: "Lore: Shadowlands") == 2)

        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        self.model.sellSkill(skillName: "Lore: Shadowlands", for: character)
        XCTAssertTrue(character.skillRank(name: "Lore: Shadowlands") == 2)

        self.model.sellSkill(skillName: "Defense", for: character)
        XCTAssertTrue(character.skillRank(name: "Defense") == 1)
        self.model.sellSkill(skillName: "Defense", for: character)
        self.model.sellSkill(skillName: "Defense", for: character)
        self.model.sellSkill(skillName: "Defense", for: character)
        XCTAssertTrue(character.skillRank(name: "Defense") == 1)

        XCTAssertTrue(character.skillRank(name: "anotherSkill") == 0)
        self.model.sellSkill(skillName: "anotherSkill", for: character)
        XCTAssertTrue(character.skillRank(name: "anotherSkill") == 0)
        self.model.buySkill(type: Item.ItemType.skills, name: "anotherSkill", for: character)
        XCTAssertTrue(character.skillRank(name: "anotherSkill") == 1)
        self.model.sellSkill(skillName: "anotherSkill", for: character)
        XCTAssertTrue(character.skillRank(name: "anotherSkill") == 0)
        self.model.sellSkill(skillName: "anotherSkill", for: character)
        self.model.sellSkill(skillName: "anotherSkill", for: character)
        XCTAssertTrue(character.skillRank(name: "anotherSkill") == 0)
        XCTAssertTrue(character.xp == 0)
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

        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.stamina, for: character)
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.willpower, for: character)
        XCTAssertTrue(character.woundPerLevel() == 6)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.healthy) == 15)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.nicked) == 21)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.grazed) == 27)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.hurt) == 33)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.injured) == 39)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.crippled) == 45)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.down) == 51)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.out) == 57)

        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.stamina, for: character)
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.willpower, for: character)
        XCTAssertTrue(character.wounds(woundLevel: WoundLevel.healthy) == 20)
        XCTAssertTrue(character.woundPerLevel() == 8)

        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.stamina, for: character)
        self.model.buyTrait(type: Item.ItemType.traits, name: TraitName.willpower, for: character)
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

    func testBuyOtherStuff() {
        let book = Book()
        self.model.create(name: "Wilson", xp: 0)
        let character = self.model.characters.first!
        let ancestor = book.ancestors[0]
        model.buyItem(type: Item.ItemType.ancestors, name: ancestor.name, points: ancestor.points, for: character)
        XCTAssertTrue(character.ancestors().count == 1)
        model.sellItem(item: character.ancestors()[0], for: character)
        XCTAssertTrue(character.ancestors().count == 0)

        let kata = book.katas[0]
        model.buyItem(type: Item.ItemType.katas, name: kata.name, points: kata.mastery, for: character)
        XCTAssertTrue(character.katas().count == 1)
        model.sellItem(item: character.katas()[0], for: character)
        XCTAssertTrue(character.katas().count == 0)

        let kiho = book.kihos[0]
        model.buyItem(type: Item.ItemType.kihos, name: kiho.name, points: kiho.mastery, for: character)
        XCTAssertTrue(character.kihos().count == 1)
        model.sellItem(item: character.kihos()[0], for: character)
        XCTAssertTrue(character.kihos().count == 0)

        model.buyItem(type: Item.ItemType.shadowlandsPowers, name: book.shadowlandsPowers[0].name, points: 0, for: character)
        XCTAssertTrue(character.shadowlandsPowers().count == 1)
        model.sellItem(item: character.shadowlandsPowers()[0], for: character)
        XCTAssertTrue(character.shadowlandsPowers().count == 0)

        let spell = book.spells[0]
        model.buyItem(type: Item.ItemType.spells, name: spell.name, points: spell.mastery ?? "0", for: character)
        XCTAssertTrue(character.spells().count == 1)
        model.sellItem(item: character.spells()[0], for: character)
        XCTAssertTrue(character.spells().count == 0)

        let tattoo = book.tattoos[0]
        model.buyItem(type: Item.ItemType.tattoos, name: tattoo.name, points: 0, for: character)
        XCTAssertTrue(character.tattoos().count == 1)
        model.sellItem(item: character.tattoos()[0], for: character)
        XCTAssertTrue(character.tattoos().count == 0)

        let weapon = book.weapons[0]
        model.buyItem(type: Item.ItemType.weapons, name: weapon.name, points: 0, for: character)
        XCTAssertTrue(character.weapons().count == 1)
        model.sellItem(item: character.weapons()[0], for: character)
        XCTAssertTrue(character.weapons().count == 0)

        let armor = book.armors[0]
        model.buyItem(type: Item.ItemType.armors, name: armor.name, points: 0, for: character)
        XCTAssertTrue(character.armors().count == 1)
        model.sellItem(item: character.armors()[0], for: character)
        XCTAssertTrue(character.armors().count == 0)
    }
}
