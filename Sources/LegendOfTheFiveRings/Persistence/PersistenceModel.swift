//
//  File.swift
//  
//
//  Created by Tharak on 29/11/20.
//

import Foundation
import CoreData

@available(iOS 11.0, *)
public final class CharacterO: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var player: String?
    @NSManaged public var xp: Int16
    @NSManaged public var items: NSSet?
    @NSManaged public var honor: Int16
    @NSManaged public var glory: Int16
    @NSManaged public var status: Int16
    @NSManaged public var shadowlandsTaint: Int16
    
    public class func fetchRequest() -> NSFetchRequest<CharacterO> {
        return NSFetchRequest<CharacterO>(entityName: String(describing: CharacterO.self))
    }
    
    static let entity = CoreDataEntityDescription.entity(
        name: String(describing: CharacterO.self),
        managedObjectClass: CharacterO.self,
        attributes: [
            .attribute(name: "id", type: .UUIDAttributeType),
            .attribute(name: "name", type: .stringAttributeType),
            .attribute(name: "player", type: .stringAttributeType),
            .attribute(name: "xp", type: .integer16AttributeType),
            .attribute(name: "honor", type: .integer16AttributeType),
            .attribute(name: "glory", type: .integer16AttributeType),
            .attribute(name: "status", type: .integer16AttributeType),
            .attribute(name: "shadowlandsTaint", type: .integer16AttributeType)
        ],
        relationships: [
            .relationship(name: "items", destination: String(describing: Itemo.self), toMany: true, deleteRule: .cascadeDeleteRule, inverse: "character")
        ])
}

@available(iOS 11.0, *)
public class Itemo: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var type: String?
    @NSManaged public var order: Int16
    @NSManaged public var points: Int16
    @NSManaged public var character: CharacterO?
    
    public class func fetchRequest() -> NSFetchRequest<Itemo> {
      return NSFetchRequest<Itemo>(entityName: String(describing: Itemo.self))
    }
    
    static let entity = CoreDataEntityDescription.entity(
        name: String(describing: Itemo.self),
        managedObjectClass: Itemo.self,
        attributes: [
            .attribute(name: "id", type: .UUIDAttributeType),
            .attribute(name: "name", type: .stringAttributeType),
            .attribute(name: "type", type: .stringAttributeType),
            .attribute(name: "order", type: .integer16AttributeType),
            .attribute(name: "points", type: .integer16AttributeType)
        ],
        relationships: [
            .relationship(name: "character", destination: String(describing: CharacterO.self), toMany: false, inverse: "items")
        ])
    
    public enum ItemType: String {
        case advantages, ancestors, armors, clan, disadvantages, families, katas, kihos, schools, shadowlandsPowers, skills,  spells, tattoos, weapons
        case info //player name
        case status // honor, glory, status, shadowlands taint
        case attributes
    }
    
    public enum attributesSubtypes: String {
        case stamina, willpower, strength, perception, reflexes, awareness, agility, intelligence, void
    }
}

@available(iOS 11.0, *)
public struct PersistenceModel {
    
    public init() { }

    public static let model: NSManagedObjectModel = CoreDataModelDescription(
        entities: [CharacterO.entity, Itemo.entity]
    ).makeModel()
}


