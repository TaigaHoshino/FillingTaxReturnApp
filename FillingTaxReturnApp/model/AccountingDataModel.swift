//
//  AccountingDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/11.
//

import UIKit
import CoreData

class AccountingDataModel {
    private static var persistentContainer: NSPersistentCloudKitContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    static func save(){
        AccountingDataModel.persistentContainer.saveContext()
    }
    
    static func deleteAccounting(accounting: Accounting) -> Bool{
        let context = persistentContainer.viewContext
        context.delete(accounting)
        do{
            try context.save()
        }
        catch{
            print(error)
            return true
        }
        return false
    }
    
    static func getAccountings() -> [Accounting]{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounting")
        do {
            let accounting = try context.fetch(request) as! [Accounting]
            return accounting
        }
        catch{
            fatalError()
        }
    }
    
    static func newAccounting() -> Accounting{
        let context = persistentContainer.viewContext
        let accounting = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context) as! Accounting
        accounting.id = UUID()
        return accounting
    }
}
