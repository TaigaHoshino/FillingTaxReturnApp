//
//  RegisterBOPAlertViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/07/28.
//

import UIKit

class BOPViewController: UIViewController {
    
    public static var initialController: Self {
        get{
            let storyboard = UIStoryboard(name: "BOP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "BOPViewController") as! Self
            return viewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
