//
//  RegisterBOPViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/06.
//

import UIKit

class RegisterBOPViewController: UIViewController {
    
    @IBOutlet weak var bopContainerView: UIView!
    
    public static var initialController: Self {
        get{
            let storyboard = UIStoryboard(name: "RegisterBOP", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "RegisterBOPViewController") as! Self
            return viewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let bopViewController = BOPViewController.initialController
        addChild(bopViewController)
        bopViewController.view.frame = bopContainerView.bounds
        bopContainerView.addSubview(bopViewController.view)
        bopViewController.didMove(toParent: self)
    }
    
}
