//
//  BaseDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/12.
//

import CoreData
import UIKit

class BaseDataModel {
    public static let persistentContainer: NSPersistentCloudKitContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    static func save(){
        BaseDataModel.persistentContainer.saveContext()
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
