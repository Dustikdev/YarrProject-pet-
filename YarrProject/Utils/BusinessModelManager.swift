import CoreData

final class BusinessModelManager {
    
    static let shared = BusinessModelManager()
    private let persistenceService = CoreDataManager.shared
    
    private init () {}
    
    func projectListData() -> ProjectsListData {
        let model: ProjectsListData = persistenceService.create()
        return model
    }
    
    func getProjectLists() -> [ProjectsListData] {
        let list = persistenceService.loadData(with: ProjectsListData.self)
        return list
    }
    
    func projectDetailsData() -> ProjectDetailsData {
        let model: ProjectDetailsData = persistenceService.create()
        return model
    }
    
    func getProjectDetails(with predicate: NSPredicate) -> [ProjectDetailsData] {
        let list = persistenceService.loadData(with: ProjectDetailsData.self, predicate: predicate)
        return list
    }
    
    func save() {
        persistenceService.saveContext()
    }
    
    func delete<T: NSManagedObject>(data: T) {
        persistenceService.delete(data: data)
    }
}
