//
//  RegisterBOPAlertViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/07/28.
//

import UIKit

class RegisterBOPViewController: UIViewController {
    
    @IBOutlet weak var bopPickerField: PickerTextField!
    
    public static var initialController: Self {
        get{
            let storyboard = UIStoryboard(name: "RegisterBOP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterBOPViewController") as! Self
            return viewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bopPickerField.setDataSource(dataSource: Datasets.incomeOrExpenditure)
    }


    @IBAction func onBackButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
