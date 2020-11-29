import XCTest
import LegendOfTheFiveRings
import CoreData

@available(iOS 11.0, *)
final class LegendOfTheFiveRingsCoreDataTests: XCTestCase {

    // MARK: - Properties
    // swiftlint:disable implicitly_unwrapped_optional
    var persistenceService: PersistenceService!
    var coreDataStack: CoreDataStack!
    // swiftlint:enable implicitly_unwrapped_optional

    override func setUp() {
        super.setUp()
        coreDataStack = TestCoreDataStack()
        persistenceService = PersistenceService(managedObjectContext: coreDataStack.mainContext, coreDataStack: coreDataStack)
        persistenceService.deleteAll()
    }

    override func tearDown() {
        super.tearDown()
        persistenceService = nil
        coreDataStack = nil
    }

    func testAddCharacter() {
        let character = persistenceService.createCharacter(name: "Death Star", xp: 45)

        XCTAssertNotNil(character, "Character should not be nil")
        XCTAssertNotNil(character.id, "id should not be nil")
        XCTAssertTrue(character.name == "Death Star")
        XCTAssertTrue(character.xp == 45)
        XCTAssertTrue(character.items?.count == 0)
    }

    func testRootContextIsSavedAfterAddingCharacter() {
        let derivedContext = coreDataStack.newDerivedContext()
        persistenceService = PersistenceService(managedObjectContext: derivedContext, coreDataStack: coreDataStack)

        expectation(
            forNotification: .NSManagedObjectContextDidSave,
            object: coreDataStack.mainContext) { _ in
              return true
        }

        derivedContext.perform {
            let character = self.persistenceService.createCharacter(name: "Death Star", xp: 100)
            XCTAssertNotNil(character)
        }

        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "Save did not occur")
        }
    }

    func testGetCharacters() {
        let newCharacter = persistenceService.createCharacter(name: "Endor", xp: 30)

        let getCharacters = persistenceService.getCharacters()

        XCTAssertNotNil(getCharacters)
        XCTAssertTrue(getCharacters?.count == 1)
        XCTAssertTrue(newCharacter.id == getCharacters?.first?.id)
    }

    func testUpdateCharacter() {
        let newCharacter = persistenceService.createCharacter(name: "Snow Planet", xp: 0)
        newCharacter.xp = 30
        let updatedCharacter = persistenceService.update(newCharacter)
        XCTAssertTrue(newCharacter.id == updatedCharacter.id)
        XCTAssertTrue(updatedCharacter.xp == 30)
    }

    func testUpdateCharacterItems() {
        let character = persistenceService.createCharacter(name: "Snow Planet", xp: 0)
        print(character)
        let item = persistenceService.createItem(for: character, name: "allies", type: Itemo.ItemType.advantages.rawValue, points: 5)
        print(character)
        XCTAssertTrue(character.items?.count == 1)
        XCTAssertTrue(character.items!.contains(item))
        XCTAssertTrue(character.xp == -5)
    }

    func testDeleteCharacter() {
        let newCharacter = persistenceService.createCharacter(name: "Starkiller Base", xp: 100)

        var fetchCharacters = persistenceService.getCharacters()
        XCTAssertTrue(fetchCharacters?.count == 1)
        XCTAssertTrue(newCharacter.id == fetchCharacters?.first?.id)

        persistenceService.delete(newCharacter)

        fetchCharacters = persistenceService.getCharacters()

        XCTAssertTrue(fetchCharacters?.isEmpty ?? false)
    }}
