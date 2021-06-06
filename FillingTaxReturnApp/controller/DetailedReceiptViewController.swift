//
//  DetailedReceiptController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/11.
//

import UIKit

class DetailedReceiptViewController: UIViewController {
    
    var receipt: Receipt?
    @IBOutlet weak var uiReceiptImage: UIImageView!
    @IBOutlet weak var tfExpense: PriceTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: (receipt?.imageName)!)
        
        let uiImage = ReadAndWriteFileUtil.loadFileFromPath(path: fileName!)
        
        uiReceiptImage.image = uiImage
        if let expense = receipt?.expense{
            tfExpense.setValue(value: expense as! Int)
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveAllContents()
    }
    
    
    @IBAction func onRegisterButtonClick(_ sender: Any) {
        
//        receipt?.countingClass = Int(detailedReceiptTableView.tfCountingClass.text)
    }
    
    private func saveAllContents(){
        if tfExpense.text != "" {
            receipt?.expense = tfExpense.getValue() as NSNumber
        }
        
        let detailedReceiptTableView = self.children[0] as! DetailedReceiptContainerTableViewController
        
        receipt?.occuredAt = DatetimeUtil.formattedDateToDate(strDate: detailedReceiptTableView.tfOccuredDate.text!)
        
        if let id = ReceiptClassesUtil.findCountingClassIdByTitle(title: detailedReceiptTableView.tfCountingClass.text!){
            receipt?.countingClass = id as NSNumber
        }
        
        AppDataModel.save()
    }
    
    static func getInitialViewController(receipt: Receipt) -> DetailedReceiptViewController {
        let storyboard = UIStoryboard(name: "DetailedReceipt", bundle: nil)
        let detailedReceitViewController = storyboard.instantiateViewController(withIdentifier: "DetailedReceiptViewController") as! DetailedReceiptViewController
        detailedReceitViewController.receipt = receipt
        return detailedReceitViewController
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
//extension DetailedReceiptViewController: UIFontPickerViewDelegate, UIPickerViewDataSource{
//    
//}
