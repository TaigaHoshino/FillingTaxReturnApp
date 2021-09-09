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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: (expense?.imageName)!)
        
        let uiImage = ReadAndWriteFileUtil.loadFileFromPath(path: fileName!)
        
        uiExpenseImage.image = uiImage
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonClick(_ sender: Any) {
        let viewController = DetailedExpenseModalViewController.getInitialController(expense: self.expense!)
        viewController.dismissCompletion = { expense in
            self.expense = expense
        }
        semiModalPresenter.viewController = viewController
        present(viewController, animated: true, completion: nil)
        
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
