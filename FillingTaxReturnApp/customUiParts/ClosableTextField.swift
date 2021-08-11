//
//  ClosableTextField.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/01.
//

import Foundation
import UIKit

class ClosableTextField: UITextField, UITextFieldDelegate {
    
    var textResultCompletion: ((_ text: String) -> Void)? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        self.delegate = self
    }
    
    @objc func done() {
        resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.text = textField.text
        self.resignFirstResponder()
        if let text = textField.text {
            textResultCompletion?(text)
        }
    
        return true
    }
}
