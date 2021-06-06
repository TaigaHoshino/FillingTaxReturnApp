//
//  PriceUtil.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/05.
//

import Foundation

extension Int {
    
    func addComma() -> String {
        let formatter = NumberFormatter()
        
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        return formatter.string(from: self as NSNumber)!
    }
    
}
