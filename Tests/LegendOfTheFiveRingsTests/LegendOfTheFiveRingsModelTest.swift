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
    let book = Book()
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

        model.buyAdvantage(name: "Allies", points: cost, for: character)
        XCTAssertTrue(character.advantages().count == 1)
        XCTAssertTrue(character.xp == xp - cost)
        XCTAssertTrue(character.advantages()[0].name == "Allies")

        model.buyAdvantage(name: "Allies2", points: cost, for: character)
        XCTAssertTrue(character.advantages().count == 2)
        XCTAssertTrue(character.xp == xp - cost - cost)
        XCTAssertTrue(character.advantages()[0].name == "Allies")
        XCTAssertTrue(character.advantages()[1].name == "Allies2")

        model.buyDisadvantages(name: "Enemies", points: cost, for: character)
        XCTAssertTrue(character.disadvantages().count == 1)
        XCTAssertTrue(character.xp == xp - cost - cost + cost)

        XCTAssertTrue(character.advantages()[0].name == "Allies")
        XCTAssertTrue(character.advantages()[1].name == "Allies2")
        XCTAssertTrue(character.disadvantages()[0].name == "Enemies")
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
        XCTAssertTrue(character.items.count == 0)
        XCTAssertTrue(character.ancestors().count == 0)
    }

    func testCharacterPickClan() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        self.model.pickClan(name: ClanName.crab.rawValue, for: character)
        XCTAssertTrue(self.model.characters.first!.items.count == 1)
        XCTAssertTrue(self.model.characters.first!.clan()?.name == ClanName.crab.rawValue)
        self.model.pickClan(name: ClanName.badger.rawValue, for: character)
        XCTAssertTrue(self.model.characters.first!.items.count == 1)
        XCTAssertTrue(character.clan()?.name == ClanName.badger.rawValue)
    }

    func testCharacterPickFamily() {
        self.model.create(name: "Wilson", xp: 100)
        let character = self.model.characters.first!
        let families = book.families
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
        self.model.pickSchool(school: book.schools[0], for: character)
        XCTAssertTrue(character.schools().count == 1)
        XCTAssertTrue(character.schools().first?.name == "Hida Bushi")
        XCTAssertTrue(character.getHonor() == 3.5)
        XCTAssertTrue(character.trait(name: TraitName.stamina) == 3)
        XCTAssertTrue(character.skills().count + character.extraSkills().count == 7)
        for skillName in ["Athletics", "Defense", "Heavy Weapons", "Intimidation", "Kenjutsu", "Lore: Shadowlands"] {
            XCTAssertTrue(character.skillRank(name: skillName) == 1, "\(skillName) is \(character.skillRank(name: skillName)) not 1")
        }
        XCTAssertTrue(character.emphases(for: "Heavy Weapons").count == 1, "\(character.emphases(for: "Heavy Weapons").count)")
        XCTAssertTrue(character.emphases(for: "Heavy Weapons").first?.name == "Tetsubo")
        
        /*
         "outfit": "Robes, Wakizashi, any one Knives, Scroll Satchel, Traveling Pack, 3 Koku",
         */
        self.model.pickSchool(school: book.schools[1], for: character)
        XCTAssertTrue(character.schools().count == 1)
        XCTAssertTrue(character.schools().first?.name == "Kuni Shugenja")
        XCTAssertTrue(character.getHonor() == 2.5)
        XCTAssertTrue(character.trait(name: TraitName.stamina) == 2)
        XCTAssertTrue(character.trait(name: TraitName.willpower) == 3)
        XCTAssertTrue(character.skills().count + character.extraSkills().count == 6, "\(character.skills().count) \(character.skills().map({$0.name}))")
        for skillName in ["Calligraphy", "Defense", "Lore: Shadowlands", "Lore: Theology", "Spellcraft"] {
            if skillName == "Lore: Shadowlands" {
                XCTAssertTrue(character.skillRank(name: skillName) == 2, "\(skillName) is \(character.skillRank(name: skillName)) instead of 2")
            } else {
                XCTAssertTrue(character.skillRank(name: skillName) == 1)
            }
        }
        XCTAssertTrue(character.emphases(for: "Calligraphy").count == 1, "\(character.emphases(for: "Calligraphy").count)")
        XCTAssertTrue(character.xp == 100)
        
        self.model.pickSchool(school: book.schools.first(where: {$0.name == "Isawa Shugenja"})!, for: character)
        XCTAssertTrue(character.schools().count == 1)
        XCTAssertTrue(character.schools().first?.name == "Isawa Shugenja")
        XCTAssertTrue(character.getHonor() == 4.5)
        XCTAssertTrue(character.trait(name: TraitName.intelligence) == 3)
        XCTAssertTrue(character.skills().count + character.extraSkills().count == 7, "\(character.skills().count) \(character.skills())")
        for skillName in ["Calligraphy", "Lore: Theology", "Medicine", "Meditation", "Spellcraft"] {
            XCTAssertTrue(character.skillRank(name: skillName) == 1)
        }
        XCTAssertTrue(character.emphases(for: "Calligraphy").count == 1, "\(character.emphases(for: "Calligraphy").count)")
        XCTAssertTrue(character.emphases(for: "Calligraphy").first?.name == "Cipher")
        
        for school in book.schools {
            model.pickSchool(school: school, for: character)
            if !school.advanced {
                if ["Kuni Shugenja", "Daidoji Iron Warriors", "Tsuruchi Archer", "Shosuro Infiltrator",
                "Utaku Battle Maiden", "Order of the Spider", "Toritaka Bushi", "Shinjo Bushi",
                "Hida Pragmatist", "Matsu Beastmasters", "Asako Henshin", "Tengoku's Fist", "Tsi Smith", "Temple of Osano-Wo", "Shinmaki Order Divination", "Shinmaki Order"].contains(school.name) {
                    XCTAssertTrue(character.skills().count + character.extraSkills().count == 6, "\(character.skills().count) \(school.name) \(school.skills ?? "")")
                } else if ["Dark Moto Cavalry"].contains(school.name) {
                    XCTAssertTrue(character.skills().count + character.extraSkills().count == 8, "\(character.skills().count) \(school.name) \(school.skills ?? "")")
                } else {
                    XCTAssertTrue(character.skills().count + character.extraSkills().count == 7, "\(character.skills().count)  \(school.name) \(school.skills ?? "")")
                }
            }
        }
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
            XCTAssertTrue(character.skills().count == 1)
        }
        XCTAssertTrue(character.skillRank(name: "skill") == 10)
        XCTAssertTrue(character.xp == -55)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 9)
        XCTAssertTrue(character.xp == -55+10, "got \(character.xp)")
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 8)
        XCTAssertTrue(character.xp == -55+10+9, "got \(character.xp)")
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 7)
        XCTAssertTrue(character.xp == -55+10+9+8, "got \(character.xp)")
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 6)
        XCTAssertTrue(character.xp == -55+10+9+8+7, "got \(character.xp)")
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 5)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6, "got \(character.xp)")
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 4)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5)
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 3)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4)
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 2)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4+3)
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 1)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4+3+2)
        XCTAssertTrue(character.skills().count == 1)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 0)
        XCTAssertTrue(character.xp == -55+10+9+8+7+6+5+4+3+2+1)
        XCTAssertTrue(character.skills().count == 0)
        self.model.sellSkill(skillName: "skill", for: character)
        XCTAssertTrue(character.skillRank(name: "skill") == 0)
        XCTAssertTrue(character.xp == 0)
        XCTAssertTrue(character.skills().count == 0)

        self.model.pickSchool(school: book.schools[1], for: character)
        let skillNames = ["Calligraphy", "Defense", "Lore: Shadowlands", "Lore: Theology", "Spellcraft"]
        for skillName in skillNames {
            if skillName == "Lore: Shadowlands" {
                XCTAssertTrue(character.skillRank(name: skillName) == 2, "\(skillName) is \(character.skillRank(name: skillName)) instead of 2")
            } else {
                XCTAssertTrue(character.skillRank(name: skillName) == 1)
            }
        }
        XCTAssertTrue(character.skills().count == skillNames.count)
        XCTAssertTrue(character.emphases(for: "Calligraphy").count == 1)
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
        
        let skillName = "Sleight of Hand"
        model.buyEmphasis(skillName: skillName, emphasisName: "Prestidigitation", for: character)
        XCTAssertTrue(character.emphases(for: skillName).count == 0)
        model.buySkill(type: .skills, name: skillName, for: character)
        model.buyEmphasis(skillName: skillName, emphasisName: "Prestidigitation", for: character)
        XCTAssertTrue(character.emphases(for: skillName).count == 1)
        model.buyEmphasis(skillName: skillName, emphasisName: "Prestidigitation", for: character)
        XCTAssertTrue(character.emphases(for: skillName).count == 1)
        model.buyEmphasis(skillName: skillName, emphasisName: "Pick Pocket", for: character)
        XCTAssertTrue(character.emphases(for: skillName).count == 2)
        model.sellSkill(skillName: skillName, for: character)
        XCTAssertTrue(character.emphases(for: skillName).count == 0)
    }

    func testPickSchool2() {
        self.model.create(name: "Wilson", xp: 0)
        let character = self.model.characters.first!
        for school in book.schools {
            model.pickSchool(school: school, for: character)
            if let traitText = character.getItem(type: .schoolTrait)?.name {
                XCTAssertNotNil(TraitName(rawValue: traitText))
            } else {
                XCTAssertTrue(school.advanced || ["Fuzake Shugenja", "Tsuno Ravager", "Tsuno Soultwister"].contains(school.name), "\(school.name)")
            }
            if !school.advanced {
                for skill in character.skills() {
                    
                    if let bookSkill = book.skills.first(where: {$0.name == skill.name}) {
                        XCTAssertTrue(!bookSkill.type.contains("Macro-skill"))
                    } else {
                        XCTAssertTrue(skill.name.contains(":"), "\(school.name) \(skill.name)")
                    }
                    for emphases in character.emphases(for: skill.name) {
                        XCTAssertTrue(character.emphases(for: skill.name).count == 1, "\(character.schools().first?.name ?? "") \(emphases.name) \(character.emphases(for: skill.name).count)")
                        XCTAssertFalse(emphases.name.contains("("))
                        XCTAssertFalse(emphases.name.contains(")"))
                    }
                }
            }

            let highs = book.skills.filter({$0.category == .high})
            let bugeis = book.skills.filter({$0.category == .bugei})
            let merchants = book.skills.filter({$0.category == .merchant})
            let lows = book.skills.filter({$0.category == .low})
            
            for extra in character.extraSkills().map({$0.name}) {
                if extra == "Bugei Skill" || extra == "Bugei Skills" {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == bugeis.count, extra)
                    continue
                }
                if ["High Skill", "High or Perform Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count, extra)
                    continue
                }
                if extra == "Merchant Skill" {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == merchants.count, extra)
                    continue
                }
                if extra == "Low Skill" {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == lows.count, extra)
                    continue
                }
                if extra.contains("Weapon Skill") {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == 12, "\(extra) \(book.skillsForExtra(text: extra).count)")
                    continue
                }
                if ["Lore", "Artisan", "Artisan Skill", "Craft Skill", "Lore Skill", "Craft Skill with 2 ranks"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == 1, "\(school.name) \(extra) \(book.skillsForExtra(text: extra).count)")
                    continue
                }
                if ["Skills", "skill", "Skill", "skills"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == book.skills.count, "\(school.name) \(extra) \(book.skillsForExtra(text: extra).count)")
                    continue
                }
                if ["High or Bugei Skill", "Bugei or High Skill", "High or Bugei Skills"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + bugeis.count, extra)
                    continue
                }
                if ["Bugei or Low Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == lows.count + bugeis.count, extra)
                    continue
                }
                if ["High or Merchant Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + merchants.count, extra)
                    continue
                }
                if ["Merchant or Low Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == lows.count + merchants.count, extra)
                    continue
                }
                if ["Acting or Artisan", "Artisan or Perform Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == 2, extra)
                    continue
                }
                if ["High or Low Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + lows.count, extra)
                    continue
                }
                if ["Low or Bugei Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == bugeis.count + lows.count, extra)
                    continue
                }
                if ["High or Bugei or Merchant Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + bugeis.count + merchants.count, extra)
                    continue
                }
                if ["High or Perform"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + bugeis.count + merchants.count, extra)
                    continue
                }
                if ["Merchant or Lore Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == merchants.count + 1, extra)
                    continue
                }
                if ["non-Low Skill", "non-Low Skills"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + bugeis.count - 1 + merchants.count, extra)
                    continue
                }
                if ["non-Bugei Skill", "High Skill or Merchant or Low Skill"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == highs.count + lows.count + merchants.count, extra)
                    continue
                }
                if ["non-High Skills"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == bugeis.count + lows.count + merchants.count, extra)
                    continue
                }
                if ["skills Acting or Artisan or Perform"].contains(extra) {
                    XCTAssertTrue(book.skillsForExtra(text: extra).count == 3, extra)
                    continue
                }
                XCTAssertTrue(book.skillsForExtra(text: extra).count == -1, "\(school.name) \(extra) \(book.skillsForExtra(text: extra).count)")
            }
        }

        if let school = book.schools.first(where: {$0.name == "Hiruma Bushi" }) {
            model.pickSchool(school: school, for: character)
            XCTAssert(character.skills().count == 6)
            XCTAssert(character.emphases(for: "Kenjutsu").first?.name == "Katana")
        }
        if let school = book.schools.first(where: {$0.name == "Yotsu Bushi" }) {
            model.pickSchool(school: school, for: character)
            XCTAssert(character.skills().count == 5)
            XCTAssert(character.emphases(for: "Stealth").first?.name == "Sneaking")
            XCTAssert(character.extraSkills().count == 2)
        }
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
        XCTAssertTrue(character.woundPenalty(woundLevel: WoundLevel.out) == 0)
    }

    func testBuyOtherStuff() {
        self.model.create(name: "Wilson", xp: 0)
        let character = self.model.characters.first!
        let ancestor = book.ancestors[0]
        model.buyAncestors(name: ancestor.name, points: ancestor.points, for: character)
        XCTAssertTrue(character.ancestors().count == 1)
        model.sellItem(item: character.ancestors()[0], for: character)
        XCTAssertTrue(character.ancestors().count == 0)

        let kata = book.katas[0]
        model.buyKatas(name: kata.name, points: kata.mastery, for: character)
        XCTAssertTrue(character.katas().count == 1)
        model.sellItem(item: character.katas()[0], for: character)
        XCTAssertTrue(character.katas().count == 0)

        let kiho = book.kihos[0]
        model.buyKihos(name: kiho.name, points: kiho.mastery, for: character)
        XCTAssertTrue(character.kihos().count == 1)
        model.sellItem(item: character.kihos()[0], for: character)
        XCTAssertTrue(character.kihos().count == 0)

        model.buyShadowlandsPowers(name: book.shadowlandsPowers[0].name, for: character)
        XCTAssertTrue(character.shadowlandsPowers().count == 1)
        model.sellItem(item: character.shadowlandsPowers()[0], for: character)
        XCTAssertTrue(character.shadowlandsPowers().count == 0)

        let spell = book.spells[0]
        model.buySpells(name: spell.name, points: spell.mastery ?? "0", for: character)
        XCTAssertTrue(character.spells().count == 1)
        model.sellItem(item: character.spells()[0], for: character)
        XCTAssertTrue(character.spells().count == 0)

        let tattoo = book.tattoos[0]
        model.buyTattoos(name: tattoo.name, for: character)
        XCTAssertTrue(character.tattoos().count == 1)
        model.sellItem(item: character.tattoos()[0], for: character)
        XCTAssertTrue(character.tattoos().count == 0)

        let weapon = book.weapons[0]
        model.buyWeapons(name: weapon.name, for: character)
        XCTAssertTrue(character.weapons().count == 1)
        model.sellItem(item: character.weapons()[0], for: character)
        XCTAssertTrue(character.weapons().count == 0)

        let armor = book.armors[0]
        model.buyArmors(name: armor.name, for: character)
        XCTAssertTrue(character.armors().count == 1)
        model.sellItem(item: character.armors()[0], for: character)
        XCTAssertTrue(character.armors().count == 0)

        XCTAssertTrue(character.items.count == 0)
    }
}
