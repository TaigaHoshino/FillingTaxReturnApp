//
//  DetailedExpenseController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/11.
//

import UIKit

class DetailedExpenseViewController: UIViewController {
    
    private var semiModalPresenter = SemiModalPresenter()
    private var expense: Expense!
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
    
    @IBAction func onUpdateButtonClick(_ sender: Any) {
        expenseModalViewController.saveAllContents()
        let dialog = UIAlertController(title: nil, message: NSLocalizedString("save.complete", comment: ""), preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: NSLocalizedString("close", comment: ""), style: .default, handler: {
            _ in
            self.dismiss(animated: true)
        }))

        self.present(dialog, animated: true)
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonClick(_ sender: Any) {
        present(expenseModalViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func onDeleteButtonClick(_ sender: Any) {
        let path = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: expense.imageName!)!
        _ = ReadAndWriteFileUtil.deleteFileFromPath(path: path)
        _ = ExpenseDataModel.deleteExpense(expense: expense)
        
        dismiss(animated: true, completion: nil)
    }
    
    static func getInitialViewController(expense: Expense) -> DetailedExpenseViewController {
        let storyboard = UIStoryboard(name: "DetailedExpense", bundle: nil)
        let detailedExpenseViewController = storyboard.instantiateViewController(withIdentifier: "DetailedExpenseViewController") as! DetailedExpenseViewController
        detailedExpenseViewController.expense = expense
        return detailedExpenseViewController
    }

}
