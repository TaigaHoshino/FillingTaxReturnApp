//
//  CameraViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/20.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var cameraView: CameraView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // シャッターボタンが押された時のアクション
    @IBAction func cameraButton_TouchUpInside(_ sender: Any) {
        cameraView.shutter()
    }
    
    static func getInitialController() -> CameraViewController {
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        return viewController
    }
    
    @IBAction func onBackButtonClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension CameraViewController: CameraViewProtocol{
    func photoOutput(uiImage: UIImage) {
        let date = Date()
        let fileName = "receipt\(DatetimeUtil.dateToSimpleDateTime(date: date))"
        let targetDirectory: String? = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: fileName)
        if let targetDirectory = targetDirectory {
            
            if(ReadAndWriteFileUtil.saveImage(image: uiImage, path: targetDirectory)){
                let receipt = ReceiptDataModel.newReceipt()
                receipt.createdAt = date
                receipt.occuredAt = date
                receipt.imageName = fileName
                receipt.isRegistered = false
                ReceiptDataModel.save()
                
                let viewController = DetailedReceiptViewController.getInitialViewController(receipt: receipt)
                present(viewController, animated: true, completion: nil)
            }
        }
    }
    
    
}
