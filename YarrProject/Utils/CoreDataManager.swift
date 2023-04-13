import CoreData

final class CoreDataManager {
    
    private lazy var context = persistentContainer.viewContext
    private(set) lazy var persistentContainer: NSPersistentContainer = {
                let container = NSPersistentContainer(name: Strings.modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            }
        })
        return container
    }()
    static let shared = CoreDataManager()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print(error)
            }
        }
    }
    
    func create<T: NSManagedObject>() -> T {
        T.init(context: context)
    }
    
    func delete<T: NSManagedObject>(data: T) {
        context.delete(data)
    }
    
    func loadData <T: NSManagedObject>(
        with type: T.Type,
        predicate: NSPredicate? = nil
    ) -> [T] {
        let entityName = String(describing: T.self)
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        if predicate != nil {
            fetchRequest.predicate = predicate
        }
        do {
            if let data = try context.fetch(fetchRequest) as? [T] {
                return data
            } else {
                return []
            }
        } catch {
            print("error \(error)")
        }
        return []
    }
    
    private init() { }
}
