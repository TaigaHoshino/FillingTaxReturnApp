//
//  TransactionEachDay.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/05/09.
//

import Foundation

class ExpensesEachDay {
    
    let date: Date
    let expenses: [Expense]
    
    init(date: Date, expenses: [Expense]){
        self.date = date
        self.expenses = expenses
    }
}
