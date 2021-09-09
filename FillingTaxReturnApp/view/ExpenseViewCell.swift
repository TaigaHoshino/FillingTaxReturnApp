//
//  ExpenseViewCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/10.
//

import UIKit

class ExpenseViewCell: UICollectionViewCell {
    
    @IBOutlet weak var occuredAtText: UILabel!
    @IBOutlet weak var countingClassLabel: UILabel!
    @IBOutlet weak var isRegisteredLabel: UILabel!
    @IBOutlet weak var uiExpenseImageView: UIImageView!
    @IBOutlet weak var uiRegisterImageView: UIImageView!
    @IBOutlet weak var uiCheckBoxView: UIImageView!
    private var _isSettingModeActive = false
    public var settingModeActive: Bool {
        set(bool){
            if bool{
                _isSettingModeActive = true
                uiCheckBoxView.isHidden = false
            }
            else {
                _isSettingModeActive = false
                isCellSelected = false
                uiCheckBoxView.image = getEmptyImage()
                uiCheckBoxView.isHidden = true
            }
        }
        get{
            return _isSettingModeActive
        }
    }
    
    private var _isCellSelected = false
    public var isCellSelected:Bool {
        set(bool) {
            if bool {
                _isCellSelected = true
                uiCheckBoxView.image = getCheckedImage()
            }
            else {
                _isCellSelected = false
                uiCheckBoxView.image = getEmptyImage()
            }
        }
        get {
            return _isCellSelected
        }
    }
    
    private var _expense: Expense!
    
    public var expense: Expense{
        get {
            return _expense
        }
    }

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
    
    func setupCell(expense: Expense){
        
        self._expense = expense
        let targetFile: String! = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: self._expense.imageName!)
        
        DispatchQueue.global().async{
            let img = ReadAndWriteFileUtil.loadFileFromPath(path: targetFile)!.resize(withPercentage: 0.1)
            DispatchQueue.main.async {
                self.uiExpenseImageView.image = img?.resize(size: self.frame.size)
                self.occuredAtText.text = DatetimeUtil.dateToFormattedDate(date: expense.occuredAt!)
            }
        }
        if Bool(truncating: NSNumber(value: expense.isRegistered)) {
            self.uiRegisterImageView.image = UIImage(named: "baseline_check_circle_outline")
            isRegisteredLabel.text = "登録済み"
        }
        else {
            self.uiRegisterImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            isRegisteredLabel.text = "未登録"
        }
        countingClassLabel.text = Datasets.findCountingClassTitleById(id: Int(expense.countingClass))
        uiCheckBoxView.image = getEmptyImage()
        isCellSelected = false
        uiCheckBoxView.isHidden = true
        
        backgroundColor = .lightGray
    }
    
    func setIsCellSelected(selected: Bool){
        
    }
    
    func getIsCellSelected() -> Bool{
        return isCellSelected
    }
    
    func onSelect(){
        
        if(_isSettingModeActive == false){
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
    
    func getEmptyImage() -> UIImage{
        return UIImage.getEmptyImage(color: .white, size: uiCheckBoxView.frame.size, imageView: uiCheckBoxView)
    }
    
    func getCheckedImage() -> UIImage {
        let image = UIImage(systemName: "checkmark")
        let resultImage = image!.resize(size: uiCheckBoxView.frame.size)
        return resultImage!
    }

}
