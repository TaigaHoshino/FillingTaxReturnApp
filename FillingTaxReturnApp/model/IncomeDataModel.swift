//
//  IncomeDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/11.
//

import UIKit
import CoreData

class IncomeDataModel: BaseDataModel {
    
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
        let entity = NSEntityDescription.entity(forEntityName: "Income", in: context)
        let income = Income(entity: entity!, insertInto: nil)
        income.id = UUID()
        return income
    }
    
    static func insertIncome(income: Income) {
        let context = persistentContainer.viewContext
        context.insert(income)
    }
}
