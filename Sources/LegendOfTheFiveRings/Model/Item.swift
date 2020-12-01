//
//  File.swift
//  
//
//  Created by Tharak on 29/11/20.
//

import Foundation
import CoreData

public class Item: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var order: Int16
    @NSManaged public var points: Int16
    @NSManaged public var character: Character
    
    public class func fetchRequest() -> NSFetchRequest<Item> {
      return NSFetchRequest<Item>(entityName: String(describing: Item.self))
    }
    
    static let entity = CoreDataEntityDescription.entity(
        name: String(describing: Item.self),
        managedObjectClass: Item.self,
        attributes: [
            .attribute(name: "id", type: .UUIDAttributeType),
            .attribute(name: "name", type: .stringAttributeType),
            .attribute(name: "type", type: .stringAttributeType),
            .attribute(name: "order", type: .integer16AttributeType),
            .attribute(name: "points", type: .integer16AttributeType)
        ],
        relationships: [
            .relationship(name: "character", destination: String(describing: Character.self), toMany: false, inverse: "items")
        ]
    )
    
    public enum ItemType: String, CaseIterable {
        case advantages, ancestors, armors, clan, disadvantages, families, katas, kihos, schools, shadowlandsPowers, skills,  spells, tattoos, weapons
        case traits
    }

    public enum TraitsNames: String, CaseIterable {
        case stamina, willpower, strength, perception, reflexes, awareness, agility, intelligence, void
    }
}
