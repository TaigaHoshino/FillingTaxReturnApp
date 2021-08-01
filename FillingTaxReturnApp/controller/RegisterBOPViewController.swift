//
//  RegisterBOPAlertViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/07/28.
//

import UIKit

class RegisterBOPViewController: UIViewController {
    
    public static var initialController: Self {
        get{
            let storyboard = UIStoryboard(name: "RegisterBOP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterBOPViewController") as! Self
            return viewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
