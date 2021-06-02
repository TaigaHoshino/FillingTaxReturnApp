//
//  TransactionListViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/26.
//

import UIKit

class TransactionListViewController: UIViewController, UICollectionViewDataSource, UITableViewDataSource {
    
    @IBOutlet weak var dateCollectionView: UICollectionView!
    @IBOutlet weak var tvTransactionList: UITableView!
    
    private var selectedDateCellIndexPath: IndexPath!
    private var receiptsEachDayList: [ReceiptsEachDay]?
    private var receiptsEachMonth: [Receipt]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateCollectionView.dataSource = self
        dateCollectionView.delegate = self
        
        dateCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        receiptsEachMonth = getReceiptEachMonth(year: 2021, month: 6)
        
        receiptsEachDayList = separateReceiptsEachDay(receipts: receiptsEachMonth)
        print(receiptsEachDayList)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let calender = Calendar.current
        
        let month = calender.component(.month, from: Date())
        
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
        
        let receipts = AppDataModel.getReceiptsByDate(from: from, to: to)
        
        return receipts
    }

}

extension TransactionListViewController {
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
            
        }
    }
}

extension TransactionListViewController{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tvTransactionList.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        return cell
    }
    
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace : CGFloat = 80
        let cellSize : CGFloat = self.view.bounds.width/3 - horizontalSpace
        return CGSize.init(width: horizontalSpace, height: 50)
    }
    
}
