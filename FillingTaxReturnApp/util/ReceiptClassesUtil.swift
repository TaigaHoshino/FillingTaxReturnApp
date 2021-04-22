//
//  DrumrollClass.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/18.
//

import Foundation

class ReceiptClassesUtil {
    public static let countingClass = [["id": 1, "title": "飲食費", "description": "飲食に使用した経費"],
                                       ["id": 2, "title": "営業関連の支払い", "description": "任入・会議・広告・外注・交際など"],
                                       ["id": 3, "title": "物品の購入等", "description": "消耗品・新聞・書籍・リースなど"],
                                       ["id": 4, "title": "設備関連の支払い", "description": "家賃・水道光熱・通信など"],
                                       ["id": 5, "title": "税・保険・手数料", "description": "任入・会議・広告・外注・交際など"],
                                       ["id": 6, "title": "給与・福利厚生", "description": "給料・社保・医療・慰労など"],
                                       ["id": 7, "title": "金銭貸借・一時支払", "description": "事業主の生活費・返済・仮払など"],
                                       ["id": 8, "title": "固定資産の購入", "description": "１年以上使う１０万円以上の物品購入"],
                                       ["id": 9, "title": "その他", "description": "いずれにもあてはまらないもの"]]
    
    public static func findCountingClassIdByTitle(title: String) -> Int?{
        for data in countingClass{
            if data["title"] as! String == title{
                return data["id"] as? Int
            }
        }
        return nil
    }
    
    public static func findCountingClassTitleById(id: Int) -> String?{
        for data in countingClass{
            if data["id"] as! Int == id{
                return data["title"] as? String
            }
        }
        return nil
    }
}
