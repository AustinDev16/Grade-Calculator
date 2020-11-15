//
//  CoreDataStack.swift
//  FinalExamCalculator
//
//  Created by Austin Blaser on 11/14/20.
//

import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    var mainQueueMOC: NSManagedObjectContext?
    var privateQueueMOC: NSManagedObjectContext?
    
    func initializeCoreData(callback: @escaping (Result<Bool, NSError>) -> Void) {
        guard let modelURL = Bundle.main.url(forResource: "FinalExamControllerModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else { return }
        let storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCoordinator
        self.privateQueueMOC = managedObjectContext
        createChildMainThreadMOC()
        
        // Connect to store
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let storeURL = documentsURL?.appendingPathComponent("FinalExamControllerModel.sqlite")
        
        DispatchQueue.global(qos: .default).async {
            let storeCoordinator = self.privateQueueMOC?.persistentStoreCoordinator
            let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            do {
                let _ = try storeCoordinator?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    callback(.success(true))
                }
            } catch let error {
                DispatchQueue.main.async {
                    callback(.failure(error as NSError))
                }
            }
        }
        
    }
    
    private func createChildMainThreadMOC() {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.parent = self.privateQueueMOC
        self.mainQueueMOC = context
    }
}
