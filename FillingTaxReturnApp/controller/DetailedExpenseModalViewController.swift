//
//  DetailedExpenseModalViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/16.
//

import UIKit

class DetailedExpenseModalViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tfExpense: PriceTextField!
    private var expense: Expense? = nil
    @IBOutlet weak var registerExpenseButton: UIButton!
    private var isRegistered: Bool = false
    private var isNew = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if expense == nil {
            expense = ExpenseDataModel.newExpense()
            isNew = true
        }

        if let expense = expense?.expense{
            tfExpense.setValue(value: Int(expense))
        }
        
        if let isRegistered = expense?.isRegistered{
            self.isRegistered = Bool(truncating: NSNumber(value: isRegistered))
            setRegisterButtonUI(bool: self.isRegistered)
        }
        // Do any additional setup after loading the view.
    }
    
    func getExpenses() -> Expense {
        return expense!
    }
    
    public func saveAllContents(){
        
        if isNew {
            _ = ExpenseDataModel.insertExpense(expense: expense!)
        }
        
        if tfExpense.text != "" {
            expense?.expense = Int64(tfExpense.getValue())
        }
        
        let detailedExpenseTableView = self.children[0] as! DetailedExpenseStaticTableViewController
        
        expense?.occuredAt = detailedExpenseTableView.tfOccuredDate.getDateValue()
        
        if let id = Datasets.findCountingClassIdByTitle(title: detailedExpenseTableView.tfCountingClass.text!){
            expense?.countingClass = Int16(id)
        }
        
        expense?.isRegistered = isRegistered
        
        ExpenseDataModel.save()
    }
    
    private func setRegisterButtonUI(bool: Bool) {
        if isRegistered {
            registerExpenseButton.backgroundColor = .blue
            registerExpenseButton.setTitle("登録済み", for: UIControl.State.normal)
        }
        else {
            registerExpenseButton.backgroundColor = .yellow
            registerExpenseButton.setTitle("未登録", for: UIControl.State.normal)
        }
    }
    
    static func getInitialController(expense: Expense) -> DetailedExpenseModalViewController {
        let storyboard = UIStoryboard(name: "DetailedExpenseModal", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailedExpenseModalViewController") as! DetailedExpenseModalViewController
        viewController.expense = expense
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

extension DetailedExpenseModalViewController: SemiModalPresenterDelegate {

    var semiModalContentHeight: CGFloat {
        return contentView.frame.height
    }
}
