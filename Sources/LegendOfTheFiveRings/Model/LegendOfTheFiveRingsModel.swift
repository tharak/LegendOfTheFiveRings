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

    public func buyItem(type: Item.ItemType, name: String, points: Int, for character: Character) {
        coreDataService.createItem(for: character, name: name, type: type, points: points)
    }

}
