//
//  IncomeDataModel.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/11.
//

import UIKit
import CoreData

class IncomeDataModel: BaseDataModel<Income> {
    
    static func newIncome() -> Income{
        let income = new()
        income.id = UUID()
        return income
    }
}
