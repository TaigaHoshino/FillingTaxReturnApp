//
//  AppDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/23.
//

import UIKit
import CoreData

class AppDataModel {
    private static var persistentContainer: NSPersistentCloudKitContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    func save(){
        AppDataModel.persistentContainer.saveContext()
    }
    
    static func newReceipt() -> Receipt{
        let context = persistentContainer.viewContext
        let receipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context) as! Receipt
        return receipt
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
