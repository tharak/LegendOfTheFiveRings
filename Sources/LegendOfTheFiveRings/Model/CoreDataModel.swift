//
//  File.swift
//  
//
//  Created by Tharak on 29/11/20.
//

import Foundation
import CoreData

public struct CoreDataModel {

    public init() { }

    public static let model: NSManagedObjectModel = CoreDataModelDescription(
        entities: [Character.entity, Item.entity]
    ).makeModel()
}


