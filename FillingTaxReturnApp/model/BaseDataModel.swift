//
//  BaseDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/12.
//

import CoreData
import UIKit

class BaseDataModel<TEntity : NSManagedObject> {

    
    public static var persistentContainer: NSPersistentCloudKitContainer! {
        get{
            return (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        }
    }
    
    static func save(){
        BaseDataModel.persistentContainer.saveContext()
    }
    
    // 新規エンティティを保存する際はこのメソッドにエンティティを通すこと
    // すでにCoreDataに追加済みのエンティティを通すとバグが発生するため注意
    static func insert(entity: TEntity) {
        let context = BaseDataModel.persistentContainer.viewContext
        context.insert(entity)
    }
    
    static func new() -> TEntity {
        let context = BaseDataModel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: String(describing: TEntity.self), in: context)
        let tEntity = TEntity(entity: entity!, insertInto: nil)
        return tEntity
    }
    
    static func delete(entity: TEntity) -> Bool {
        let context = persistentContainer.viewContext
        context.delete(entity)
        do{
            try context.save()
        }
        catch{
            print(error)
            return true
        }
        return false
    }
    
    static func getAll() -> [TEntity] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: TEntity.self))
        do {
            let entities = try context.fetch(request) as! [TEntity]
            return entities
        }
        catch{
            fatalError()
        }
    }
    
    public static func getFetchedResultController(sortDescriptors: [NSSortDescriptor] = [],
                                                                      predicate: NSPredicate? = nil,
                                                                      sectionNameKeyPath: String? = nil,
                                                                      cacheName: String? = nil) -> NSFetchedResultsController<TEntity> {
        
        let context = BaseDataModel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<TEntity>(entityName: String(describing: TEntity.self))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return NSFetchedResultsController<TEntity>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
    }
}

extension NSPersistentCloudKitContainer{
    func saveContext(){
        saveContext(context: viewContext)
    }

    func saveContext(context: NSManagedObjectContext) {
            
        // 変更がなければ何もしない
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
