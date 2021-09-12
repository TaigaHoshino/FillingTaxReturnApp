//
//  TransactionListViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/26.
//

import UIKit
import CoreData

class TransactionListViewController: UIViewController {
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    
    private var selectedDateCellIndexPath: IndexPath!
    private var currentSelectedDate = Date()
    private var expenseTableView: ExpenseTableViewController!
    
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
        
        dateCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        currentSelectedDate = Date()
        
        expenseTableView = ExpenseTableViewController.getInitialController(date: currentSelectedDate)
        contentViewController = expenseTableView
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
            
            let year = calender.component(.year, from: Date())
            let month = indexPath[1] + 1
            
            cell.setupCell(date: DatetimeUtil.formattedDateToDate(strDate: "\(year)年\(month)月1日"))
            
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
