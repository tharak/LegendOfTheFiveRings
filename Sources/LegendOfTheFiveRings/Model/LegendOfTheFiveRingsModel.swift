//
//  File.swift
//  
//
//  Created by Tharak on 30/11/20.
//

import Foundation

public class LegendOfTheFiveRingsModel: ObservableObject {

    @Published public var characters: [Character]

    private var coreDataService: CoreDataService
    private var coreDataStack: CoreDataStack

    public init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
        coreDataService = CoreDataService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        characters = coreDataService.getCharacters() ?? []
    }

    public func create(name: String, xp: Int) {
        coreDataService.createCharacter(name: name, xp: xp)
        characters = coreDataService.getCharacters() ?? []
    }

    public func update(character: Character) {
        coreDataService.update(character)
        characters = coreDataService.getCharacters() ?? []
    }

    public func delete(character: Character) {
        coreDataService.delete(character)
        characters = coreDataService.getCharacters() ?? []
    }
    
    public func delete(item: Item, character: Character) {
        coreDataService.delete(item)
        characters = coreDataService.getCharacters() ?? []
    }

    func buyItem(type: Item.ItemType, name: String, points: String, for character: Character) {
        if let points = Int(points) {
            self.buyItem(type: type, name: name, points: points, for: character)
        }
    }

    func buyItem(type: Item.ItemType, name: String, points: Int, for character: Character) {
        coreDataService.createItem(for: character, name: name, type: type, points: points)
    }

    func sellItem(item: Item, for character: Character) {
        character.xp = character.xp + item.points
        delete(item: item, character: character)
    }

    public func pickClan(name: String, for character: Character) {
        if let clan = character.clan() {
            delete(item: clan, character: character)
            pickClan(name: name, for: character)
        } else {
            buyItem(type: Item.ItemType.clans, name: name, points: 0, for: character)
        }
    }

    public func pickFamily(family: Family, for character: Character) {
        if let familyItem = character.family() {
            if let familyTrait = character.getItem(type: Item.ItemType.familyTrait) {
                delete(item: familyTrait, character: character)
            }
            delete(item: familyItem, character: character)
            pickFamily(family: family, for: character)
        } else {
            buyItem(type: Item.ItemType.families, name: family.name, points: 0, for: character)
            if let trait = family.bonusTrait() {
                buyTrait(type: Item.ItemType.familyTrait, name: trait, for: character)
            }
        }
    }

    public func pickSchool(school: School, for character: Character) {
        if let schoolItem = character.schools().first {
            if character.hasMultipleSchools() {
                buyItem(type: Item.ItemType.schools, name: school.name, points: 0, for: character)
            } else {
                if let schoolTrait = character.getItem(type: Item.ItemType.schoolTrait) {
                    delete(item: schoolTrait, character: character)
                }
                for schoolSkill in character.getItems(type: Item.ItemType.schoolSkill) {
                    delete(item: schoolSkill, character: character)
                }
                delete(item: schoolItem, character: character)
                pickSchool(school: school, for: character)
            }
        } else {
            if let honor = school.honor, let honorf = Float(honor) {
                character.honor = Int16(honorf * 10)
            }
            if let trait = school.bonusTrait() {
                buyTrait(type: Item.ItemType.schoolTrait, name: trait, for: character)
            }
            for skillName in skillNames(from: school.skills) {
                buySkill(type: .schoolSkill, name: skillName, for: character)
            }
            buyItem(type: Item.ItemType.schools, name: school.name, points: 0, for: character)
        }
    }

    public func buyEmphasis(skillName: String, emphasisName: String, for character: Character) {
        buyItem(type: Item.ItemType.emphasis(skillName: skillName), name: emphasisName, points: 2, for: character)
    }

    public func buySkill(type: Item.ItemType, name: String, for character: Character) {
        let price = type == .skills ? (character.skillRank(name: name) + 1) : 0
        buyItem(type: type, name: name, points: price, for: character)
    }

    public func sellSkill(skill: Item, for character: Character) {
        if let skillItem = character.getItems(type: .skills, name: skill.name).last {
            sellItem(item: skillItem, for: character)
        }
    }

    public func sellSkill(skillName: String, for character: Character) {
        if let skillItem = character.getItems(type: .skills, name: skillName).last {
            sellItem(item: skillItem, for: character)
        }
    }

    public func buyTrait(type: Item.ItemType, name: TraitName, for character: Character) {
        let price = type == .traits ? (character.trait(name: name) + 1) * 4 : 0        
        buyItem(type: type, name: name.rawValue, points: price, for: character)
    }

    public func sellTrait(name: TraitName, for character: Character) {
        if let traitItem = character.getItems(type: .traits, name: name.rawValue).last {
            sellItem(item: traitItem, for: character)
        }
    }

    func skillNames(from schoolSkills: String?) -> [String] {
        guard let schoolSkills = schoolSkills else {
            return []
        }
        var notRankOne: [String] = []
        let skillsNames = schoolSkills.split(separator: ",")
            .compactMap { (name) -> String? in
                if name.contains("any") {
                    return nil
                }
                if let numberString = name.split(separator: " ").last,
                    let numberChar = numberString.first,
                    let number = Int(numberString) {
                        for _ in 0..<number {
                            notRankOne.append(name.split(separator: numberChar).joined().trimmingCharacters(in: .whitespacesAndNewlines))
                        }
                        return nil
                    }
                return name.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        return skillsNames + notRankOne
    }
}
