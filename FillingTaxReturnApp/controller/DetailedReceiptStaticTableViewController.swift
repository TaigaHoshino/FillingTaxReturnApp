//
//  DetailedReceiptContainerTableTableViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/13.
//

import UIKit

class DetailedReceiptStaticTableViewController: UITableViewController {

    @IBOutlet weak var tfCountingClass: PickerTextField!
    @IBOutlet weak var tfOccuredDate: DatePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataSource = Datasets.countingClass
        var data = [String]()
        
        for title in dataSource{
            data.append(title["title"] as! String)
        }

        tfCountingClass.setDataSource(dataSource: data)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let parent = self.parent as! DetailedReceiptModalViewController
        let receipt = parent.getReceipt()
        
        if receipt.occuredAt == nil {
            tfOccuredDate.setDateValue(date: receipt.createdAt!)
        }
        else {
            tfOccuredDate.setDateValue(date: receipt.occuredAt!)
        }
        
        if let id = receipt.countingClass{
            if let title = Datasets.findCountingClassTitleById(id: id.intValue){
                tfCountingClass.setDefaultValue(value: title)
            }
            else{
                tfCountingClass.setDefaultValue(value: Datasets.countingClass.first!["title"] as! String)
            }
            
        }
        else {
            tfCountingClass.setDefaultValue(value: Datasets.countingClass.first!["title"] as! String)
        }
    }
}
