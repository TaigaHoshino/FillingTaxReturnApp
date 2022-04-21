//
//  EditDetailedIncomeViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/18.
//

import UIKit

class EditDetailedIncomeViewController: UIViewController {
    
    private var income: Income!
    
    @IBOutlet weak var containerView: UIView!
    private var detaliedIncomeStaticTableViewController: DetailedIncomeStaticTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detaliedIncomeStaticTableViewController = DetailedIncomeStaticTableViewController.getInitialController(income: income)
        addChild(detaliedIncomeStaticTableViewController)
        detaliedIncomeStaticTableViewController.view.frame = containerView.bounds
        containerView.addSubview(detaliedIncomeStaticTableViewController.view)
        detaliedIncomeStaticTableViewController.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }
    

    public static func getInitialController(income: Income) -> Self {
        let storyboard = UIStoryboard(name: "EditDetailedIncome", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "EditDetailedIncomeViewController") as! Self
        viewController.income = income
        return viewController
    }
    
    @IBAction func onCloseButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDeleteButtonClick(_ sender: Any) {
        _ = IncomeDataModel.delete(entity: income)
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        detaliedIncomeStaticTableViewController.save()
    }
    
}
