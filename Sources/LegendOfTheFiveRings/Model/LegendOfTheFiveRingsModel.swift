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

    func buyItem(type: Item.ItemType, name: String, points: Int, for character: Character) {
        coreDataService.createItem(for: character, name: name, type: type, points: points)
    }

    func sellItem(item: Item, points: Int, for character: Character) {
        character.xp = character.xp + Int16(points)
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
            for traitItem in character.getItems(type: Item.ItemType.traits) {
                delete(item: traitItem, character: character)
            }
            delete(item: familyItem, character: character)
            pickFamily(family: family, for: character)
        } else {
            buyItem(type: Item.ItemType.families, name: family.name, points: 0, for: character)
            if let trait = family.bonusTrait() {
                buyTrait(name: trait, for: character)
            }
        }
    }

    public func pickSchool(school: School, for character: Character) {
        if character.schools().isEmpty {
            buyItem(type: Item.ItemType.schools, name: school.name, points: 0, for: character)
            if let trait = school.bonusTrait() {
                buyTrait(name: trait, for: character)
            }
        } else {
            if character.hasMultipleSchools() {
                buyItem(type: Item.ItemType.schools, name: school.name, points: 0, for: character)
            } else {
                
            }
        }
    }

    public func buyTrait(name: TraitName, for character: Character) {
        let price = (character.trait(name: name) + 1) * 4
        buyItem(type: Item.ItemType.traits, name: name.rawValue, points: price, for: character)
    }

    public func sellTrait(name: TraitName, for character: Character) {
        let traits = character.trait(name: name)
        if traits > 2 {
            let price = traits * 4
            sellItem(item: character.getItem(type: .traits, name: name.rawValue)!, points: price, for: character)
        }
    }
}
