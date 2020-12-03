//
//  File.swift
//  
//
//  Created by Tharak on 29/11/20.
//

import Foundation
import CoreData
import CoreDataModelDescription

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

    func getItems(type: Item.ItemType? = nil, name: String? = nil) -> [Item] {
        if let type = type {
            if let name = name {
                let filtered = items.filtered(using: NSPredicate(format: "type == %@ && name == %@", String(describing: type.self), name)) as? Set<Item> ?? []
                return filtered.sorted(by: {$0.order < $1.order})
            }
            let filtered = items.filtered(using: NSPredicate(format: "type == %@", String(describing: type.self))) as? Set<Item> ?? []
            return filtered.sorted(by: {$0.order < $1.order})
        }
        return (items as? Set<Item> ?? []).sorted(by: {$0.order < $1.order})
    }

    func getItem(type: Item.ItemType, name: String? = nil) -> Item? {
        getItems(type: type, name: name).first
    }

    public func hasMultipleSchools() -> Bool {
        return getItem(type: Item.ItemType.advantages, name: "Multiple Schools") != nil
    }

    public func clan() -> Item? {
        return getItem(type: Item.ItemType.clans)
    }

    public func getHonor() -> Float {
        return Float(honor) / 10
    }

    public func getGlory() -> Float {
        return Float(glory) / 10
    }

    public func getStatus() -> Float {
        return Float(status) / 10
    }

    public func getShadowlandsTaint() -> Float {
        return Float(shadowlandsTaint) / 10
    }

    public func schools() -> [Item] {
        return getItems(type: .schools)
    }

    public func family() -> Item? {
        return getItems(type: .families).first
    }

    public func trait(name: TraitName) -> Int {
        return 2 + getItems(type: .traits, name: name.rawValue).count
                    + getItems(type: .schoolTrait, name: name.rawValue).count
                    + getItems(type: .familyTrait, name: name.rawValue).count
    }

    public func skillRank(name: String) -> Int {
        return getItems(type: .skills, name: name).count
            + getItems(type: .schoolSkill, name: name).count
    }

    public func skills() -> [Item] {
        return getItems(type: .skills)
                + getItems(type: .schoolSkill)
    }

    public func emphases(for skillName: String) -> [Item] {
        return getItems(type: Item.ItemType.emphasis(skillName: skillName))
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

    public func ancestors() -> [Item] {
        return getItems(type: .ancestors)
    }

    public func katas() -> [Item] {
        return getItems(type: .katas)
    }

    public func kihos() -> [Item] {
        return getItems(type: .kihos)
    }

    public func shadowlandsPowers() -> [Item] {
        return getItems(type: .shadowlandsPowers)
    }

    public func spells() -> [Item] {
        return getItems(type: .spells)
    }

    public func tattoos() -> [Item] {
        return getItems(type: .tattoos)
    }

    public func weapons() -> [Item] {
        return getItems(type: .weapons)
    }

    public func armors() -> [Item] {
        return getItems(type: .armors)
    }

    public func advantages() -> [Item] {
        return getItems(type: .advantages)
    }

    public func disadvantages() -> [Item] {
        return getItems(type: .disadvantages)
    }    
}
