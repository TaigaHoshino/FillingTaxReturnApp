//
//  AppDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/23.
//

import UIKit
import CoreData

class ReceiptDataModel {
    private static var persistentContainer: NSPersistentCloudKitContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    static func save(){
        ReceiptDataModel.persistentContainer.saveContext()
    }
    
    static func deleteReceipt(receipt: Receipt) -> Bool{
        let context = persistentContainer.viewContext
        context.delete(receipt)
        do{
            try context.save()
        }
        catch{
            print(error)
            return true
        }
        return false
    }
    
    static func getReceipts() -> [Receipt]{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Receipt")
        do {
            let receipts = try context.fetch(request) as! [Receipt]
            return receipts
        }
        catch{
            fatalError()
        }
    }
    
    static func getReceiptById(id: UUID) -> [Receipt]?{
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        var receipt: [Receipt]?
        
        do{
            receipt = try context.fetch(fetchRequest)
            
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        return receipt
    }
    
    static func getReceiptsByDate(from: Date, to: Date, registeredOnly: Bool = false) -> [Receipt]?{
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        let predicate: NSPredicate
        if registeredOnly {
            predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@) AND (isRegistered == %@)", from as CVarArg, to as CVarArg, 0)
        }
        else {
            predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@)", from as CVarArg, to as CVarArg)
        }
        let sortDescripter = NSSortDescriptor(key: "occuredAt", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescripter]
        var receipts: [Receipt]?
        
        do{
            receipts = try context.fetch(fetchRequest)
            
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        return receipts
    }
    
    static func newReceipt() -> Receipt{
        let context = persistentContainer.viewContext
        let receipt = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context) as! Receipt
        receipt.id = UUID()
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
