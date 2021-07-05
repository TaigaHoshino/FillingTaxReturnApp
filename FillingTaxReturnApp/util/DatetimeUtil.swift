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
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyyMMddHHmmss"

        return dateFormatter.string(from: date)
    }
    
    static func dateToFormattedDateTime(date: Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    static func dateToFormattedDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter.string(from: date)
    }
    
    static func formattedDateToDate(strDate: String) -> Date{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        return dateFormatter.date(from: strDate)!
    }
    
    static func formattedDateTimeToDate(strDate: String) -> Date{
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        return dateFormatter.date(from: strDate)!
    }
    
    static func truncateDate(date: Date) -> Date{
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month, .day], from: date)
        let truncateDay = calendar.date(from:comps)
        return truncateDay!
    }
    
}

extension Date {
    var month: Int {
        let calender = Calendar.current
        let month = calender.component(.month, from: self)
        return month
    }
    
    var year: Int {
        let calender = Calendar.current
        let year = calender.component(.year, from: self)
        return year
    }
}
