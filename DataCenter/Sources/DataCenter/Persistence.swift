//
//  Persistence.swift
//  RunMate
//
//  Created by macbook on 10/4/2023.
//
import CoreData
import OSLog

public enum PersistenceError: Error {
    /*
     The object model configuration is bad.
     */
    case failedToLoadObjectModel
    /*
     Acess to persistence store is broken.
     */
    case failedToLoadStore(Error)
}

public struct PersistenceController {
    let logger = OSLog(subsystem: Bundle.module.description, category: .pointsOfInterest)
    private static let _shared = try? PersistenceController()
    public static func shared() throws -> Self {
        guard let _shared else { throw PersistenceError.failedToLoadObjectModel }
        return _shared
    }

    public static var preview: PersistenceController = {
        let result = try! PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    public let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) throws {
        guard let objectModelURL = Bundle.module.url(forResource: "RunMate", withExtension: "momd"),
              let objectModel = NSManagedObjectModel(contentsOf: objectModelURL) else {
            throw PersistenceError.failedToLoadObjectModel
        }
        
        container = NSPersistentCloudKitContainer(name: "RunMate", managedObjectModel: objectModel)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
