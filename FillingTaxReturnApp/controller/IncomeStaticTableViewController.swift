//
//  BOPStaticTableViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/01.
//

import UIKit

class IncomeStaticTableViewController: UITableViewController {
    
    @IBOutlet weak var expense: PriceTextField!
    @IBOutlet weak var countingClass: PickerTextField!
    @IBOutlet weak var client: AddablePickerTextField!
    @IBOutlet weak var occuredDate: DatePickerTextField!
    @IBOutlet weak var items: ClosableTextField!
    @IBOutlet weak var memo: ClosableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAllItems()
        
        client.setUserDefaults(userDefaultsKey: AppData.clientsDefaultKey, noSelectionValue: "未選択")
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        client.save()
    }
    
    private func initAllItems() {
        expense.text = "0"
        
        var incomeTitles: [String] = []
        for data in Datasets.incomeClass {
            incomeTitles.append(data["title"] as! String)
        }

        countingClass.setDataSource(dataSource: incomeTitles)
        countingClass.setDefaultValue(value: incomeTitles.first!)
    }
    
}
