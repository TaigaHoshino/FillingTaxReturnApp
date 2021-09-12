//
//  DrumrollClass.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/18.
//

import Foundation

class Datasets {
    public static let countingClass = [["id": 1, "title": "飲食費", "description": "飲食に使用した経費"],
                                       ["id": 2, "title": "営業関連の支払い", "description": "任入・会議・広告・外注・交際など"],
                                       ["id": 3, "title": "物品の購入等", "description": "消耗品・新聞・書籍・リースなど"],
                                       ["id": 4, "title": "設備関連の支払い", "description": "家賃・水道光熱・通信など"],
                                       ["id": 5, "title": "税・保険・手数料", "description": "任入・会議・広告・外注・交際など"],
                                       ["id": 6, "title": "給与・福利厚生", "description": "給料・社保・医療・慰労など"],
                                       ["id": 7, "title": "金銭貸借・一時支払", "description": "事業主の生活費・返済・仮払など"],
                                       ["id": 8, "title": "固定資産の購入", "description": "１年以上使う１０万円以上の物品購入"],
                                       ["id": 9, "title": "その他", "description": "いずれにもあてはまらないもの"]]
    
    
    public static let incomeClass = [["id": 1, "title": "利子所得", "description": "公社債や預貯金の利子、貸付信託や公社債投信の収益の分配などから生じる所得"],
                                     ["id": 2, "title": "配当所得", "description": "株式の配当、証券投資信託の収益の分配、出資の剰余金の分配などから生じる所得"],
                                     ["id": 3, "title": "不動産所得", "description": "不動産、土地の上に存する権利、船舶、航空機の貸付けなどから生じる所得"],
                                     ["id": 4, "title": "事業所得", "description": "商業・工業・農業・漁業・自由業など、事業から生じる所得"],
                                     ["id": 5, "title": "給与所得", "description": "給料・賞与などの所得"],
                                     ["id": 6, "title": "退職所得", "description": "退職によって受ける所得"],
                                     ["id": 7, "title": "山林所得", "description": "５年を超えて所有していた山林を伐採して売ったり、又は立木のまま売った所得"],
                                     ["id": 8, "title": "譲渡所得", "description": "事業用の固定資産や家庭用の資産などを売った所得"],
                                     ["id": 9, "title": "一時所得", "description": "クイズの賞金や満期保険金などの所得"],
                                     ["id": 10, "title": "雑所得", "description": "いずれにもあてはまらない所得"]]
    
    public static let incomeOrExpenditure = ["収入", "支出"]
    
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
    
    public static func findIncomeClassById(id: Int) -> [String: Any]? {
        for data in incomeClass{
            if data["id"] as! Int == id{
                return data
            }
        }
        return nil
    }
    
    public static func findIncomeClassByTitle(title: String) -> [String: Any]? {
        for data in incomeClass{
            if data["title"] as! String == title{
                return data
            }
        }
        return nil
    }
}
