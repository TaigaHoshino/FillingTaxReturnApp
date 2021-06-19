//
//  DetailedReceiptModalViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/16.
//

import UIKit

class DetailedReceiptModalViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    static func getInitialController() -> DetailedReceiptModalViewController {
        let storyboard = UIStoryboard(name: "DetailedReceiptModal", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailedReceiptModalViewController") as! DetailedReceiptModalViewController
        return viewController
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

extension DetailedReceiptModalViewController: SemiModalPresenterDelegate {

    var semiModalContentHeight: CGFloat {
        return contentView.frame.height
    }
}
