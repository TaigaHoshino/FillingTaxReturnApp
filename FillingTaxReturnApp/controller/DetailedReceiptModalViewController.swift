//
//  DetailedReceiptModalViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/16.
//

import UIKit

class DetailedReceiptModalViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tfExpense: PriceTextField!
    private var receipt: Receipt!
    @IBOutlet weak var registerReceiptButton: UIButton!
    private var isRegistered: Bool = false
    
    var dismissCompletion: ((_ recept: Receipt) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if let expense = receipt?.expense{
            tfExpense.setValue(value: expense as! Int)
        }
        
        if let isRegistered = receipt?.isRegistered{
            self.isRegistered = Bool(truncating: isRegistered)
            setRegisterButtonUI(bool: self.isRegistered)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismissCompletion?(receipt)
        saveAllContents()
    }
    
    func getReceipt() -> Receipt {
        return receipt
    }
    
    private func saveAllContents(){
        if tfExpense.text != "" {
            receipt?.expense = tfExpense.getValue() as NSNumber
        }
        
        let detailedReceiptTableView = self.children[0] as! DetailedReceiptStaticTableViewController
        
        receipt?.occuredAt = DatetimeUtil.formattedDateToDate(strDate: detailedReceiptTableView.tfOccuredDate.text!)
        
        if let id = ReceiptClassesUtil.findCountingClassIdByTitle(title: detailedReceiptTableView.tfCountingClass.text!){
            receipt?.countingClass = id as NSNumber
        }
        
        receipt?.isRegistered = NSNumber(value: isRegistered)
        
        ReceiptDataModel.save()
    }
    
    private func setRegisterButtonUI(bool: Bool) {
        if isRegistered {
            registerReceiptButton.backgroundColor = .blue
            registerReceiptButton.setTitle("登録済み", for: UIControl.State.normal)
        }
        else {
            registerReceiptButton.backgroundColor = .yellow
            registerReceiptButton.setTitle("未登録", for: UIControl.State.normal)
        }
    }
    
    static func getInitialController(receipt: Receipt) -> DetailedReceiptModalViewController {
        let storyboard = UIStoryboard(name: "DetailedReceiptModal", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailedReceiptModalViewController") as! DetailedReceiptModalViewController
        viewController.receipt = receipt
        return viewController
    }
    
    @IBAction func onRegisterButtonClick(_ sender: Any) {
        isRegistered = !isRegistered
        setRegisterButtonUI(bool: isRegistered)
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
