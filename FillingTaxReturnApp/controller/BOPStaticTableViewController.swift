//
//  BOPStaticTableViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/01.
//

import UIKit

class BOPStaticTableViewController: UITableViewController {
    
    @IBOutlet weak var countingClass: PickerTextField!
    @IBOutlet weak var client: AddablePickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        countingClass.setDataSource(dataSource: ["未選択"])
        client.setDataSource(dataSource: ["未選択"], protectFromDelete: ["未選択"])
    }
    
    
}
