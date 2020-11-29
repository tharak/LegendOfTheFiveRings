//
//  File.swift
//  
//
//  Created by Tharak on 29/11/20.
//

import Foundation
import CoreData

@available(iOS 11.0, *)
public class Character: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var player: String
    @NSManaged public var xp: Int16
    @NSManaged public var items: NSSet
    @NSManaged public var honor: Int16
    @NSManaged public var glory: Int16
    @NSManaged public var status: Int16
    @NSManaged public var shadowlandsTaint: Int16
    
    public class func fetchRequest() -> NSFetchRequest<Character> {
        return NSFetchRequest<Character>(entityName: String(describing: Character.self))
    }
    
    static let entity = CoreDataEntityDescription.entity(
        name: String(describing: Character.self),
        managedObjectClass: Character.self,
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
            .relationship(name: "items", destination: String(describing: Item.self), toMany: true, deleteRule: .cascadeDeleteRule, inverse: "character")
        ])
}
