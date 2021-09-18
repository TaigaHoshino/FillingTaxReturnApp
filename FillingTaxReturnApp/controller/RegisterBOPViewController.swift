//
//  RegisterBOPViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/06.
//

import UIKit

class RegisterBOPViewController: UIViewController {
    
    @IBOutlet weak var bopContainerView: UIView!
    
    var contentViewController: UIViewController? {
        didSet {
          // 問題1の対応
          // セットされていた子を削除
          oldValue?.willMove(toParent: nil)
          oldValue?.view.removeFromSuperview()
          oldValue?.removeFromParent()

          // 問題2の対応 - 1
          // viewがロードされていない場合、子は追加するが子のviewの追加は行わない
            addChild(contentViewController!)  // (b)
            contentViewController!.didMove(toParent: self)

          guard isViewLoaded else {
            return
          }
          setupContentView()
        }
    }
    
    private func setupContentView() {
        guard let contentViewController = contentViewController else {
          return
        }
        let isAlreadyAdded = (contentViewController.isViewLoaded) && bopContainerView.subviews.contains(contentViewController.view)
        guard isAlreadyAdded == false else {
          return // 二重呼び出し防止
        }

        contentViewController.view.frame = bopContainerView.bounds
        bopContainerView.addSubview(contentViewController.view)  // (c)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let incomeController = DetailedIncomeStaticTableViewController.getInitialController()
        contentViewController = incomeController
    }
    
    @IBAction func onSaveButtonClick(_ sender: Any) {
        if contentViewController is DetailedIncomeStaticTableViewController {
            let viewController = contentViewController as! DetailedIncomeStaticTableViewController
            viewController.save()
        }
        dismiss(animated: true, completion: nil)
    }
    
    public static func getInitialController() -> Self {
        let storyboard = UIStoryboard(name: "RegisterBOP", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RegisterBOPViewController") as! Self
        return viewController
    }
    
}
