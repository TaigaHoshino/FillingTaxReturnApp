//
//  DatetimeUtil.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/24.
//

import Foundation

class DatetimeUtil{
    static func dateToSimpleDateTime(date: Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyyMMddHHmmss"

        return dateFormatter.string(from: date)
    }
    
    static func dateToFormattedDateTime(date: Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
}
