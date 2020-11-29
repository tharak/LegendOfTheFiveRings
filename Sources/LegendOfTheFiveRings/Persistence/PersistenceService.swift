/// Copyright (c) 2020 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation
import CoreData

@available(iOS 11.0, *)
public final class PersistenceService {
    // MARK: - Properties
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack

    // MARK: - Initializers
    public init(managedObjectContext: NSManagedObjectContext, coreDataStack: CoreDataStack) {
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        
        self.deleteAll()
    }
}

// MARK: - Public
@available(iOS 11.0, *)
extension PersistenceService {
    @discardableResult
    public func createCharacter(name: String, xp: Int) -> Character {
        let character = Character(context: managedObjectContext)
        character.id = UUID()
        character.name = name
        character.player = ""
        character.xp = Int16(xp)
        character.honor = 0
        character.glory = 0
        character.status = 0
        character.shadowlandsTaint = 0
        coreDataStack.saveContext(managedObjectContext)
        return character
    }

    @discardableResult
    public func createItem(for character: Character, name: String, type: String, points: Int) -> Item {
        let item = Item(context: managedObjectContext)
        item.id = UUID()
        item.order = Int16(character.items.count)
        item.name = name
        item.type = type
        item.points = Int16(points)
        item.character = character
        character.xp = character.xp - item.points
        coreDataStack.saveContext(managedObjectContext)
        return item
    }
    
    public func getCharacters() -> [Character]? {
        let reportFetch: NSFetchRequest<Character> = Character.fetchRequest()
        do {
            let results = try managedObjectContext.fetch(reportFetch)
            return results
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        return nil
    }

    @discardableResult
    public func update(_ character: Character) -> Character {
        coreDataStack.saveContext(managedObjectContext)
        return character
    }
    
    public func delete(_ character: Character) {
        managedObjectContext.delete(character)
        coreDataStack.saveContext(managedObjectContext)
    }
    
    public func deleteAll() {
        
        let characters = getCharacters() ?? []
        for character in characters {
            managedObjectContext.delete(character)
        }
        coreDataStack.saveContext(managedObjectContext)
    }
}
