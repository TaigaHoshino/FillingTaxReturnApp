//
//  PriceTextField.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/19.
//

import UIKit

class PriceTextField: UITextField {
    
    private let formatter = NumberFormatter()
    
    init(){
        super.init(frame: CGRect.zero)
        setInit()
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        setInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setInit()
    }
    
    private func setInit(){
        keyboardType = UIKeyboardType.numberPad
        
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([doneItem], animated: true)
        
        self.inputAccessoryView = toolbar
        
        delegate = self
    }
    
    private func addComma(strNumber: String) -> String{
        if(strNumber != "") {
            let strNumber = removeComma(strNumber: strNumber)
            return formatter.string(from: Int(strNumber)! as NSNumber)!
        }else{
            return ""
        }
    }
    
    private func removeComma(strNumber: String) -> String{
        return strNumber.replacingOccurrences(of: ",", with: "")
    }
    
    func setValue(value: Int){
        text = addComma(strNumber: String(value))
    }
    
    func getValue() -> Int{
        var strNumber = "0"
        
        if text != nil{
            strNumber = removeComma(strNumber: text!)
        }
        return Int(strNumber)!
    }
    
    @objc func done(){
        endEditing(true)
    }
    
}

extension PriceTextField: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        text = addComma(strNumber: text!)
        
        guard let position = self.position(from: selectedTextRange!.start, offset: text!.count) else {return}
        
        selectedTextRange = textRange(from: position, to: position)
    }
}
