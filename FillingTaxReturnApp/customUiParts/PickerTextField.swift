//
//  PickerTextField.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/17.
//

import UIKit

class PickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var dataSource = [String]()
    private var picker: UIPickerView!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        
        picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([doneItem], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    func setDataSource(dataSource: [String]){
        self.dataSource = dataSource
        self.inputView = picker
    }
    
    func setDefaultValue(value: String){
        
        guard let index = dataSource.firstIndex(of: value) else {return}
        picker.selectRow(index, inComponent: 0, animated: true)
        self.text = value
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.text = dataSource[row]
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = dataSource[row]
    }
    
    @objc func done(){
        self.endEditing(true)
    }
}
