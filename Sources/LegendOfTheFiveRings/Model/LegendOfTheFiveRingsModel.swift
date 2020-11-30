//
//  File.swift
//  
//
//  Created by Tharak on 30/11/20.
//

import Foundation

public class LegendOfTheFiveRingsModel: ObservableObject {
 
    private var coreDataService: CoreDataService
    private var coreDataStack: CoreDataStack

    public init(coreDataStack: CoreDataStack = CoreDataStack()) {
        self.coreDataStack = coreDataStack
        coreDataService = CoreDataService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }
    
    public func getCharacters() -> [Character] {
        return coreDataService.getCharacters() ?? []
    }
    
    public func create(name: String, xp: Int) -> Character {
        return coreDataService.createCharacter(name: name, xp: xp)
    }
    
    public func update(character: Character) -> Character {
        return coreDataService.update(character)
    }
    
    public func delete(character: Character) {
        coreDataService.delete(character)
    }
    
}
