//
//  BOPStaticTableViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/01.
//

import UIKit

class DetailedIncomeStaticTableViewController: UITableViewController {
    
    private var income: Income? = nil
    
    @IBOutlet weak var expense: PriceTextField!
    @IBOutlet weak var countingClass: PickerTextField!
    @IBOutlet weak var client: AddablePickerTextField!
    @IBOutlet weak var occuredDate: DatePickerTextField!
    @IBOutlet weak var items: ClosableTextField!
    @IBOutlet weak var memo: ClosableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initAllItems()
        setupTable()
        
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
        client.setUserDefaults(userDefaultsKey: AppData.clientsDefaultKey, noSelectionValue: "未選択")
    }
    
    public func save() {
        IncomeDataModel.insertIncome(income: income!)
        income!.money = Int64(expense.getValue())
        income!.countingClass = Int16(Datasets.findIncomeClassByTitle(title: countingClass.text!)!["id"] as! Int)
        income!.client = client.text
        income!.occuredAt = occuredDate.getDateValue()
        income!.item = items.text
        income!.memo = memo.text
        
        IncomeDataModel.save()
    }
    
    public static func getInitialController(income: Income? = nil) -> Self {
        let storyboard = UIStoryboard(name: "DetailedIncome", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "DetailedIncomeStaticTableViewController") as! Self
        controller.income = income
        return controller
    }
    
    private func setupTable() {
        guard let income = income else {
            income = IncomeDataModel.newIncome()
            return}
        
        expense.setValue(value: Int(income.money))
        let value = Datasets.findIncomeClassById(id: Int(income.countingClass))!["title"] as! String
        countingClass.setDefaultValue(value: value)
        client.text = income.client
        occuredDate.setDateValue(date: income.occuredAt!)
        items.text = income.item
        memo.text = income.memo
        
    }
        
}
