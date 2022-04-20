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
    static func insert(entity: TEntity) -> TEntity {
        let context = BaseDataModel.persistentContainer.viewContext
        context.insert(entity)
        return entity
    }
    
    static func new() -> TEntity {
        let context = BaseDataModel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        let tEntity = TEntity(entity: entity!, insertInto: nil)
        return tEntity
    }
    
    public static func getFetchedResultController<T: NSManagedObject>(sortDescriptors: [NSSortDescriptor] = [],
                                                                      predicate: NSPredicate? = nil,
                                                                      sectionNameKeyPath: String? = nil,
                                                                      cacheName: String? = nil) -> NSFetchedResultsController<T> {
        
        let context = BaseDataModel.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        return NSFetchedResultsController<T>(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
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
