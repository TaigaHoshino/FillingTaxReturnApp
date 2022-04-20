//
//  DetailedExpenseModalViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/16.
//

import UIKit

// 支出オプション用モーダルビューのコントローラー
// 支出系ビューのモーダルビューとして利用すること
class DetailedExpenseModalViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tfExpense: PriceTextField!
    private var _expense: Expense!
    var expense: Expense {
        get{
            return _expense
        }
    }
    @IBOutlet weak var registerExpenseButton: UIButton!
    private var isRegistered: Bool = false
    private var isNew = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ExpenseDataModel.getExpenseById(id: _expense!.id!) == nil {
            isNew = true
        }

        if let expense = _expense?.expense{
            tfExpense.setValue(value: Int(expense))
        }
        
        if let isRegistered = _expense?.isRegistered{
            self.isRegistered = Bool(truncating: NSNumber(value: isRegistered))
            setRegisterButtonUI(bool: self.isRegistered)
        }
        // Do any additional setup after loading the view.
    }
    
    public func saveAllContents(){
        
        if isNew {
            ExpenseDataModel.insert(entity: _expense!)
        }
        
        if tfExpense.text != "" {
            _expense?.expense = Int64(tfExpense.getValue())
        }
        
        let detailedExpenseTableView = self.children[0] as! DetailedExpenseStaticTableViewController
        
        _expense?.occuredAt = detailedExpenseTableView.tfOccuredDate.getDateValue()
        
        if let id = Datasets.findCountingClassIdByTitle(title: detailedExpenseTableView.tfCountingClass.text!){
            _expense?.countingClass = Int16(id)
        }
        
        _expense?.isRegistered = isRegistered
        
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
        viewController._expense = expense
        return viewController
    }
    
    @IBAction func onRegisterButtonClick(_ sender: Any) {
        isRegistered = !isRegistered
        setRegisterButtonUI(bool: isRegistered)
    }

}

extension DetailedExpenseModalViewController: SemiModalPresenterDelegate {

    var semiModalContentHeight: CGFloat {
        return contentView.frame.height
    }
}
