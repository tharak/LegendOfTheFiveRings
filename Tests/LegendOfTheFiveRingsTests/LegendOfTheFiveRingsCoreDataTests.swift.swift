import XCTest
import LegendOfTheFiveRings
import CoreData

final class LegendOfTheFiveRingsCoreDataTests: XCTestCase {

    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var coreDataService: CoreDataService!
    var coreDataStack: CoreDataStack!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        coreDataService = CoreDataService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataService = nil
        coreDataStack = nil
    }

    func testAddCharacter() {
        let character = coreDataService.createCharacter(name: "Death Star", xp: 45)
        XCTAssertNotNil(character, "Character should not be nil")
        XCTAssertNotNil(character.id, "id should not be nil")
        XCTAssertTrue(character.player.isEmpty)
        XCTAssertTrue(character.glory == 0)
        XCTAssertTrue(character.honor == 0)
        XCTAssertTrue(character.status == 0)
        XCTAssertTrue(character.shadowlandsTaint == 0)
        XCTAssertTrue(character.name == "Death Star")
        XCTAssertTrue(character.xp == 45)
        XCTAssertTrue(character.items.count == 0)
    }

    func testRootContextIsSavedAfterAddingCharacter() {
        let derivedContext = coreDataStack.newDerivedContext()
        coreDataService = CoreDataService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)

        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) { _ in
              return true
        }

        derivedContext.perform {
            let character = self.coreDataService.createCharacter(name: "Death Star", xp: 100)
            XCTAssertNotNil(character)
        }

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testGetCharacters() {
        let newCharacter = coreDataService.createCharacter(name: "Endor", xp: 30)

        let getCharacters = coreDataService.getCharacters()

        XCTAssertNotNil(getCharacters)
        XCTAssertTrue(getCharacters?.count == 1)
        XCTAssertTrue(newCharacter.id == getCharacters?.first?.id)
    }

    func testUpdateCharacter() {
        let newCharacter = coreDataService.createCharacter(name: "Snow Planet", xp: 0)
        newCharacter.xp = 30
        let updatedCharacter = coreDataService.update(newCharacter)
        XCTAssertTrue(newCharacter.id == updatedCharacter.id)
        XCTAssertTrue(updatedCharacter.xp == 30)
    }

    func testUpdateCharacterItems() {
        let character = coreDataService.createCharacter(name: "Snow Planet", xp: 0)
        print(character)
        let item = coreDataService.createItem(for: character, name: "allies", type: Item.ItemType.advantages.rawValue, points: 5)
        print(character)
        XCTAssertTrue(character.items.count == 1)
        XCTAssertTrue(character.items.contains(item))
        XCTAssertTrue(character.xp == -5)
    }

    func testDeleteCharacter() {
        let newCharacter = coreDataService.createCharacter(name: "Starkiller Base", xp: 100)

        var fetchCharacters = coreDataService.getCharacters()
        XCTAssertTrue(fetchCharacters?.count == 1)
        XCTAssertTrue(newCharacter.id == fetchCharacters?.first?.id)

        coreDataService.delete(newCharacter)

        fetchCharacters = coreDataService.getCharacters()

        XCTAssertTrue(fetchCharacters?.isEmpty ?? false)
    }
    
    
}
