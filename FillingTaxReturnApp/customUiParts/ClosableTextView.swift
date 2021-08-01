//
//  ClosableTextView.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/01.
//

import Foundation
import UIKit

class ClosableTextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([doneItem], animated: true)
        self.inputAccessoryView = toolbar
    }
    
    @objc func done() {
        self.resignFirstResponder()
    }
    
}
