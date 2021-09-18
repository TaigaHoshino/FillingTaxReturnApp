//
//  TransactionListViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/26.
//

import UIKit
import CoreData
import LabelSwitch

class TransactionListViewController: UIViewController {
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    private var selectedDateCellIndexPath: IndexPath!
    private var currentSelectedDate = Date()
    private var expenseTableView: ExpenseTableViewController!
    private var incomeTableView: IncomeTableViewController!
    private var labelSwitch: LabelSwitch!
    @IBOutlet weak var navigationItems: UINavigationItem!
    @IBOutlet weak var yearPicker: PickerTextField!
    
    var contentViewController: UIViewController? {
        didSet {
          // 問題1の対応
          // セットされていた子を削除
          oldValue?.willMove(toParent: nil)
          oldValue?.view.removeFromSuperview()
          oldValue?.removeFromParent()

          // 問題2の対応 - 1
          // viewがロードされていない場合、子は追加するが子のviewの追加は行わない
            addChild(contentViewController!)  // (b)
            contentViewController!.didMove(toParent: self)

          guard isViewLoaded else {
            return
          }
          setupContentView()
        }
    }
    
    private func setupContentView() {
        guard let contentViewController = contentViewController else {
          return
        }
        let isAlreadyAdded = (contentViewController.isViewLoaded) && containerView.subviews.contains(contentViewController.view)
        guard isAlreadyAdded == false else {
          return // 二重呼び出し防止
        }

        contentViewController.view.frame = containerView.bounds
        containerView.addSubview(contentViewController.view)  // (c)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        currentSelectedDate = Date()
        
        incomeTableView = IncomeTableViewController.getInitialController(date: currentSelectedDate)
        expenseTableView = ExpenseTableViewController.getInitialController(date: currentSelectedDate)
        contentViewController = expenseTableView
        
        let ls = LabelSwitchConfig(text: "収入", textColor: .white, font: UIFont.boldSystemFont(ofSize: 20), backgroundColor: .green)

        let rs = LabelSwitchConfig(text: "経費", textColor: .white, font: UIFont.boldSystemFont(ofSize: 20), backgroundColor: .orange)

        labelSwitch = LabelSwitch(center: .zero, leftConfig: ls, rightConfig: rs)
        labelSwitch.delegate = self
        
        let button1 = UIButton(frame: CGRect(x: 2, y: 2, width: 60, height: 20))
            button1.setTitle("one", for: .normal)
        button1.backgroundColor = UIColor.black
        
        let bopSwitch = UIBarButtonItem(customView: labelSwitch)
        
        navigationItems.rightBarButtonItem = bopSwitch
        
        var years: [String] = []
        for i in 2000...Date().year + 1 {
            years.append(String(i))
        }
        yearPicker.setDataSource(dataSource: years)
        yearPicker.setDefaultValue(value: String(Date().year))
        yearPicker.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        let month = currentSelectedDate.month
        
        // 今日の月のコレクションセルを探し、中央に表示して選択状態にする
        selectedDateCellIndexPath = IndexPath(row: month - 1, section: 0)
        dateCollectionView.scrollToItem(at: selectedDateCellIndexPath, at: .centeredHorizontally, animated: false)
        
    }

}

extension TransactionListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath)
        
        if let cell = cell as? DateCell {
            
            let calender = Calendar.current
            
            let year = calender.component(.year, from: currentSelectedDate)
            let month = indexPath[1] + 1
            
            cell.setupCell(date: DatetimeUtil.strDateToDate(strDate: String(format: NSLocalizedString("formattedStrDate", comment: ""), String(year), String(month), "1"),
                                                            format: String(format: NSLocalizedString("formattedStrDate", comment: ""), "yyyy", "MM", "dd"))!)
            
            if selectedDateCellIndexPath == indexPath{
                cell.onSelect()
            }
            else{
                cell.setDefault()
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        if let cell = cell as? DateCell{
            
            let preSelectedCell = collectionView.cellForItem(at: selectedDateCellIndexPath) as? DateCell
            preSelectedCell?.setDefault()
            cell.onSelect()
            selectedDateCellIndexPath = indexPath
            currentSelectedDate = cell.getDate()
            expenseTableView.setDate(date: currentSelectedDate)
            
        }
    }
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 50)
    }
    
}

extension TransactionListViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let newDate = DatetimeUtil.strDateToDate(strDate: String(format: NSLocalizedString("formattedStrDate", comment: ""), textField.text!, String(currentSelectedDate.month), "1"),
                                                 format: String(format: NSLocalizedString("formattedStrDate", comment: ""), "yyyy", "MM", "dd"))
        currentSelectedDate = newDate!
        dateCollectionView.reloadData()
        expenseTableView.setDate(date: currentSelectedDate)
    }
}

extension TransactionListViewController: LabelSwitchDelegate {
    func switchChangToState(sender: LabelSwitch) {
        switch sender.curState {
        case .L:
            contentViewController = expenseTableView
        case .R:
            contentViewController = incomeTableView
        }
    }
}
