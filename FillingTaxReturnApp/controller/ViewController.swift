//
//  ViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onShowTransactionButtonClick(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TransactionList", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "TransactionListViewController") as! TransactionListViewController
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onCameraButtonClicked(_ sender: Any) {
        let viewController = CameraViewController.getInitialController()
        present(viewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onIncomeButtonClick(_ sender: Any) {
        let viewController = RegisterBOPViewController.getInitialController()
        present(viewController, animated: true, completion: nil)
    }
}

