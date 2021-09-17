//
//  DetailedExpenseController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/11.
//

import UIKit

class DetailedExpenseViewController: UIViewController {
    
    private var semiModalPresenter = SemiModalPresenter()
    var expense: Expense!
    @IBOutlet weak var uiExpenseImage: UIImageView!
    private var expenseModalViewController: DetailedExpenseModalViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: (expense?.imageName)!)
        
        let uiImage = ReadAndWriteFileUtil.loadFileFromPath(path: fileName!)
        
        expenseModalViewController = DetailedExpenseModalViewController.getInitialController(expense: self.expense!)
        semiModalPresenter.viewController = expenseModalViewController
        
        uiExpenseImage.image = uiImage
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        present(expenseModalViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        expenseModalViewController.saveAllContents()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonClick(_ sender: Any) {
        present(expenseModalViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func onDeleteButtonClick(_ sender: Any) {
        let path = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: expense.imageName!)!
        if ExpenseDataModel.deleteExpense(expense: expense){
            _ = ReadAndWriteFileUtil.deleteFileFromPath(path: path)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    static func getInitialViewController(expense: Expense) -> DetailedExpenseViewController {
        let storyboard = UIStoryboard(name: "DetailedExpense", bundle: nil)
        let detailedExpenseViewController = storyboard.instantiateViewController(withIdentifier: "DetailedExpenseViewController") as! DetailedExpenseViewController
        detailedExpenseViewController.expense = expense
        return detailedExpenseViewController
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
//
//extension DetailedExpenseViewController: UIFontPickerViewDelegate, UIPickerViewDataSource{
//    
//}
