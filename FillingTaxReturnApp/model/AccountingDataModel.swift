//
//  IncomeDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/11.
//

import UIKit
import CoreData

class IncomeDataModel {
    private static var persistentContainer: NSPersistentCloudKitContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    static func save(){
        IncomeDataModel.persistentContainer.saveContext()
    }
    
    static func deleteIncome(income: Income) -> Bool{
        let context = persistentContainer.viewContext
        context.delete(income)
        do{
            try context.save()
        }
        catch{
            print(error)
            return true
        }
        return false
    }
    
    static func getIncomes() -> [Income]{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Income")
        do {
            let income = try context.fetch(request) as! [Income]
            return income
        }
        catch{
            fatalError()
        }
    }
    
    static func newIncome() -> Income{
        let context = persistentContainer.viewContext
        let income = NSEntityDescription.insertNewObject(forEntityName: "Receipt", into: context) as! Income
        income.id = UUID()
        return income
    }
}
