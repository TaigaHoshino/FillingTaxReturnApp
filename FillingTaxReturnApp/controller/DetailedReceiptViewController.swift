//
//  DetailedReceiptController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/11.
//

import UIKit

class DetailedReceiptViewController: UIViewController {
    
    private var semiModalPresenter = SemiModalPresenter()
    var receipt: Receipt?
    @IBOutlet weak var uiReceiptImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileName = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: (receipt?.imageName)!)
        
        let uiImage = ReadAndWriteFileUtil.loadFileFromPath(path: fileName!)
        
        uiReceiptImage.image = uiImage
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onEditButtonClick(_ sender: Any) {
        let viewController = DetailedReceiptModalViewController.getInitialController(receipt: self.receipt!)
        viewController.registerCompletion = { () in
            self.dismiss(animated: true, completion: nil)
        }
        viewController.dismissCompletion = { receipt in
            self.receipt = receipt
        }
        semiModalPresenter.viewController = viewController
        present(viewController, animated: true, completion: nil)
        
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
