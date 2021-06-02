//
//  TransactionEachDay.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/05/09.
//

import Foundation

class ReceiptsEachDay {
    
    let date: Date
    let receipts: [Receipt]
    
    init(date: Date, receipts: [Receipt]){
        self.date = date
        self.receipts = receipts
    }
}
