//
//  File.swift
//  
//
//  Created by Tharak on 29/11/20.
//

import Foundation
import CoreData

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
        ]
    )

    func getItems(type: Item.ItemType) -> Set<Item> {
        return items.filtered(using: NSPredicate(format: "type == %@", type.rawValue)) as? Set<Item> ?? []
    }

    func getItems(type: Item.ItemType, name: String) -> Set<Item> {
        return items.filtered(using: NSPredicate(format: "type == %@ && name == %@", type.rawValue, name)) as? Set<Item> ?? []
    }

    public func clans() -> Set<Item> {
        return getItems(type: .clan)
    }

    public func schools() -> Set<Item> {
        return getItems(type: .schools)
    }

    public func trait(name: TraitName) -> Int {
        return 2 + getItems(type: .traits, name: name.rawValue).count
    }

    public func ring(name: RingName) -> Int {
        switch name {
        case .air:
            return min(trait(name: TraitName.awareness),
                       trait(name: TraitName.reflexes))
        case .fire:
            return min(trait(name: TraitName.agility),
                       trait(name: TraitName.intelligence))
        case .water:
            return min(trait(name: TraitName.strength),
                       trait(name: TraitName.perception))
        case .earth:
            return min(trait(name: TraitName.stamina),
                       trait(name: TraitName.willpower))
        case .void:
            return trait(name: TraitName.void)
        }
    }

    public func insight() -> Int {
        return getItems(type: .skills).count + RingName.allCases.reduce(0) {$0 + ring(name: $1)} * 10
    }

    public func rank() -> Int {
        switch insight() {
        case ..<150:
            return 1
        case ..<175:
            return 2
        case ..<200:
            return 3
        case ..<150:
            return 1
        case ..<175:
            return 2
        case ..<200:
            return 3
        case ..<225:
            return 4
        case ..<250:
            return 5
        case ..<275:
            return 6
        case ..<300:
            return 7
        case ..<325:
            return 8
        case ..<350:
            return 9
        default:
            return 10
        }
    }

    public func wounds(woundLevel: WoundLevel) -> Int {
        let healthy = self.ring(name: RingName.earth) * 5
        let perLevel = self.woundPerLevel()
        switch woundLevel {
        case .healthy:
            return healthy
        case .nicked:
            return healthy + perLevel
        case .grazed:
            return healthy + perLevel * 2
        case .hurt:
            return healthy + perLevel * 3
        case .injured:
            return healthy + perLevel * 4
        case .crippled:
            return healthy + perLevel * 5
        case .down:
            return healthy + perLevel * 6
        case .out:
            return healthy + perLevel * 7
        }
    }

    public func woundPerLevel() -> Int {
        return self.ring(name: RingName.earth) * 2
    }

    public func woundPenalty(woundLevel: WoundLevel) -> Int {
        switch woundLevel {
        case .healthy:
            return 0
        case .nicked:
            return 3
        case .grazed:
            return 5
        case .hurt:
            return 10
        case .injured:
            return 15
        case .crippled:
            return 20
        case .down:
            return 40
        case .out:
            return 100
        }
    }
}
