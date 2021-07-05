//
//  TransactionListViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/26.
//

import UIKit

class TransactionListViewController: UIViewController {
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    
    @IBOutlet weak var tvTransactionList: UITableView!
    
    private var selectedDateCellIndexPath: IndexPath!
    private var receiptsEachDayList: [ReceiptsEachDay] = []
    private var currentSelectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        tvTransactionList.dataSource = self
        tvTransactionList.delegate = self
        
        dateCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        currentSelectedDate = Date()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // 選択されたDateの年月を取得
        let year = currentSelectedDate.year
        let month = currentSelectedDate.month
        
        let receiptsEachMonth = getReceiptEachMonth(year: year, month: month)!
        
        // 取引一覧の日付ごとのセクション分けをするためにデータを仕分ける
        receiptsEachDayList = separateReceiptsEachDay(receipts: receiptsEachMonth)
        tvTransactionList.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let month = currentSelectedDate.month
        
        // 今日の月のコレクションセルを探し、中央に表示して選択状態にする
        selectedDateCellIndexPath = IndexPath(row: month - 1, section: 0)
        dateCollectionView.scrollToItem(at: selectedDateCellIndexPath, at: .centeredHorizontally, animated: false)
    }
    
    // 日付で昇順ソートしたreceiptListを引数にすること
    private func separateReceiptsEachDay(receipts: [Receipt]) -> [ReceiptsEachDay]{
        
        var receiptList: [Receipt] = []
        var receiptsEachDayList: [ReceiptsEachDay] = []
        
        if receipts.count == 0 {
            return receiptsEachDayList
        }
        
        var separateDay: Date = DatetimeUtil.truncateDate(date: receipts.first!.occuredAt!)
        
        for receipt in receipts {
            let truncateDay = DatetimeUtil.truncateDate(date: receipt.occuredAt!)
    
            if separateDay == truncateDay {
                receiptList.append(receipt)
            }
            else{
                receiptsEachDayList.append(ReceiptsEachDay(date: separateDay, receipts: receiptList))
                receiptList = []
                receiptList.append(receipt)
                separateDay = truncateDay
            }
        }
        
        receiptsEachDayList.append(ReceiptsEachDay(date: separateDay, receipts: receiptList))
        
        return receiptsEachDayList
    }
    
    private func getReceiptEachMonth(year: Int, month: Int) -> [Receipt]?{
        let from = DatetimeUtil.formattedDateToDate(strDate: "\(year)年\(month)月1日")
        var to: Date
        
        if month != 12 {
            to = DatetimeUtil.formattedDateToDate(strDate: "\(year)年\(month + 1)月1日")
        }
        else{
            to = DatetimeUtil.formattedDateToDate(strDate: "\(year + 1)年1月1日")
        }
        
        let receipts = ReceiptDataModel.getReceiptsByDate(from: from, to: to, registeredOnly: true)
        
        return receipts
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
            let year = currentSelectedDate.year
            let month = currentSelectedDate.month
            let receiptsEachMonth = getReceiptEachMonth(year: year, month: month)!
            receiptsEachDayList = separateReceiptsEachDay(receipts: receiptsEachMonth)
            tvTransactionList.reloadData()
        }
    }
}

extension TransactionListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return receiptsEachDayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receiptsEachDayList[section].receipts.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DatetimeUtil.dateToFormattedDate(date: receiptsEachDayList[section].date)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tvTransactionList.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        if let cell = cell as? TransactionCell {
            cell.setupCell(receipt: receiptsEachDayList[indexPath.section].receipts[indexPath.row])
        }
        
        return cell
    }
    
}

extension TransactionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tvTransactionList.cellForRow(at: indexPath)
        
        if let cell = cell as? TransactionCell {
            
            let detailedReceitViewController = DetailedReceiptViewController.getInitialViewController(receipt: cell.getReceipt())
            present(detailedReceitViewController, animated: true, completion: nil)
        }
    }
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 50)
    }
    
}
