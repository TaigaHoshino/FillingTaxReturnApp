//
//  DatePickerTextField.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/18.
//

import UIKit

class DatePickerTextField: UITextField {
    
    private var datePicker: UIDatePicker!

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
        let toolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: 0, height: 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolbar.setItems([doneItem], animated: true)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        self.inputView = datePicker
        self.inputAccessoryView = toolbar
        
        datePicker.addTarget(self, action: #selector(dateValueChanged(sender:)), for: UIControl.Event.valueChanged)
        text = DatetimeUtil.dateToFormattedDate(date: Date())
    }
    
    func setDateValue(date: Date){
        text = DatetimeUtil.dateToFormattedDate(date: date)
    }
    
    public func getDateValue() -> Date {
        return DatetimeUtil.formattedDateToDate(strDate: self.text!)
    }
    
    @objc func dateValueChanged(sender:UIDatePicker){
        text = DatetimeUtil.dateToFormattedDate(date: sender.date)
    }
    
    @objc func done(){
        resignFirstResponder()
    }
}
