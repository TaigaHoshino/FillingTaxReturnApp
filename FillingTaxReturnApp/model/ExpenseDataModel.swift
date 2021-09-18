//
//  AppDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/23.
//

import UIKit
import CoreData

class ExpenseDataModel: BaseDataModel {
    
    static func deleteExpense(expense: Expense) -> Bool{
        let context = persistentContainer.viewContext
        context.delete(expense)
        do{
            try context.save()
        }
        catch{
            print(error)
            return true
        }
        return false
    }
    
    static func getExpenses() -> [Expense]{
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        do {
            let expenses = try context.fetch(request) as! [Expense]
            return expenses
        }
        catch{
            fatalError()
        }
    }
    
    static func getExpenseById(id: UUID) -> [Expense]?{
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicate = NSPredicate(format: "id = '\(id)'")
        fetchRequest.predicate = predicate
        var expenses: [Expense]?
        
        do{
            expenses = try context.fetch(fetchRequest)
            
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        return expenses
    }
    
    static func getExpensesByIsRegistered(isRegistered: Bool) -> [Expense]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let intBool = Bool(isRegistered)
        let predicate = NSPredicate(format: "isRegistered = '\(intBool)'")
        fetchRequest.predicate = predicate
        var expenses: [Expense]?
        
        do{
            expenses = try context.fetch(fetchRequest)
            
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        return expenses
    }
    
    static func getExpensesByDate(from: Date, to: Date, registeredOnly: Bool = false) -> [Expense]?{
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        let predicate: NSPredicate
        if registeredOnly {
            predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@) AND (isRegistered <> 'false')", from as CVarArg, to as CVarArg)
        }
        else {
            predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@)", from as CVarArg, to as CVarArg)
        }
        let sortDescripter = NSSortDescriptor(key: "occuredAt", ascending: true)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescripter]
        var expenses: [Expense]?
        
        do{
            expenses = try context.fetch(fetchRequest)
            
        }
        catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
        return expenses
    }
    
    static func newExpense() -> Expense{
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Expense", in: context)
        let expense = Expense(entity: entity!, insertInto: nil)
        expense.id = UUID()
        return expense
    }
    
    static func insertExpense(expense: Expense) -> Expense {
        let context = persistentContainer.viewContext
        context.insert(expense)
        return expense
    }
    
}
