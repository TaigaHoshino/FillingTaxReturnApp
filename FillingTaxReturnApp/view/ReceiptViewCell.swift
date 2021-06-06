//
//  ReceiptViewCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/02.
//

import UIKit

class ReceiptViewCell: UICollectionViewCell {
    
    @IBOutlet weak var occuredAtText: UILabel!
    @IBOutlet weak var uiReceiptImageView: UIImageView!
    @IBOutlet weak var uiRegisterImageView: UIImageView!
    @IBOutlet weak var uiCheckBoxView: UIImageView!
    private var isSettingModeActive = false
    private var isCellSelected = false
    private var receipt: Receipt!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibViewSet()
      }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.xibViewSet()
    }

    internal func xibViewSet() {

    }
    
    func setupCell(receipt: Receipt){
        
        DispatchQueue.global().async{
            let targetFile: String! = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: receipt.imageName!)
            let img = ReadAndWriteFileUtil.loadFileFromPath(path: targetFile)!.resize(withPercentage: 0.1)
            DispatchQueue.main.async {
                self.uiReceiptImageView.image = img?.resize(size: self.frame.size)
                self.occuredAtText.text = DatetimeUtil.dateToFormattedDate(date: receipt.occuredAt!)
                self.uiRegisterImageView.image = UIImage(named: "baseline_check_circle_outline")
            }
        }
        self.receipt = receipt
        uiCheckBoxView.image = getEmptyImage()
        isCellSelected = false
        uiCheckBoxView.isHidden = true
        
        backgroundColor = .lightGray
    }
    
    func setIsCellSelected(selected: Bool){
        if selected {
            isCellSelected = true
            uiCheckBoxView.image = getCheckedImage()
        }
        else {
            isCellSelected = false
            uiCheckBoxView.image = getEmptyImage()
        }
    }
    
    func getIsCellSelected() -> Bool{
        return isCellSelected
    }
    
    func onSelect(){
        
        if(isSettingModeActive == false){
            return
        }
        
        if isCellSelected == false {
            uiCheckBoxView.image = getCheckedImage()
        }
        else{
            uiCheckBoxView.image = getEmptyImage()
        }
        
        isCellSelected = !isCellSelected
    }
    
    func acitivateSettingMode(){
        isSettingModeActive = true
        uiCheckBoxView.isHidden = false
    }
    
    func inactivateSettingMode(){
        isSettingModeActive = false
        isCellSelected = false
        uiCheckBoxView.image = getEmptyImage()
        uiCheckBoxView.isHidden = true
    }
    
    func getEmptyImage() -> UIImage{
        return UIImage.getEmptyImage(color: .white, size: uiCheckBoxView.frame.size, imageView: uiCheckBoxView)
    }
    
    func getCheckedImage() -> UIImage {
        let image = UIImage(systemName: "checkmark")
        let resultImage = image!.resize(size: uiCheckBoxView.frame.size)
        return resultImage!
    }
    
    func getReceipt() -> Receipt{
        return receipt
    }

}
