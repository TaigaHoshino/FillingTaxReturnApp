//
//  AddableTextField.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/08/01.
//

import Foundation
import UIKit

class AddablePickerTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var dataSource = [String]()
    private var protectData = [String]()
    private var picker: UIPickerView!
    private var textField: ClosableTextField!
    
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
        
        textField = createTextField()
        
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 0, height: 45))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let toolbarTextField = UIBarButtonItem(customView: textField)
        
        let deleteButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 40, height: 40))
        deleteButton.setImage(UIImage(systemName: "trash.fill"), for: UIControl.State.normal)
        deleteButton.addTarget(self, action: #selector(onDeleteButtonClick), for: .touchUpInside)
        let toolbarDeleteButton = UIBarButtonItem(customView: deleteButton)
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([doneItem, flexible, toolbarTextField, toolbarDeleteButton], animated: true)
        
        self.inputAccessoryView = toolbar
    }
    
    @objc func onAddButtonClick(_sender: Any) {
        
    }
    
    func setDataSource(dataSource: [String], protectFromDelete: [String] = []){
        self.dataSource = dataSource
        self.protectData = protectFromDelete
        self.inputView = picker
    }

    private func addDataSource(text: String){
        self.dataSource.append(text)
        picker.reloadAllComponents()
    }
    
    private func removeDataSource(){
        if protectData.contains(self.text!){
            return
        }
        let index = self.dataSource.firstIndex(where: {$0.hasPrefix(self.text!)})
        self.dataSource.remove(at: index!)
        picker.reloadAllComponents()
    }
    
    @objc func onDeleteButtonClick() {
        removeDataSource()
    }
    
    func setDefaultValue(value: String){
        
        guard let index = dataSource.firstIndex(of: value) else {return}
        text = value
        picker.selectRow(index, inComponent: 0, animated: true)
    }
    
    private func createTextField() -> ClosableTextField{
        let returnValue = ClosableTextField(frame: CGRect.init(x: 0, y: 0, width: 200, height: 40))
        returnValue.textResultCompletion = { text in
            self.addDataSource(text: text)
            returnValue.text = ""
        }
        returnValue.center = CGPoint(x: self.frame.width/2, y: self.frame.height)
        returnValue.borderColor = UIColor.gray
        returnValue.borderWidth = 1
        returnValue.cornerRadius = 5
        returnValue.textAlignment = NSTextAlignment.right
        return returnValue
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.text = dataSource[row]
    }
    
    @objc func done(){
        self.endEditing(true)
    }
}

