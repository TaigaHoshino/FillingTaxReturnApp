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
    
    @IBOutlet weak var tvTransactionList: UITableView!
    
    private var selectedDateCellIndexPath: IndexPath!
    private var currentSelectedDate = Date()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Expense> = {
        let sortDescripter = NSSortDescriptor(key: "occuredAt", ascending: true)
        
        let result = getMonthRange(date: currentSelectedDate)
        let from = result["from"]!
        let to = result["to"]!
        
        let predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@) AND (isRegistered <> 'false')", from as CVarArg, to as CVarArg)
        let controller: NSFetchedResultsController<Expense> = BaseDataModel.getFetchedResultController(sortDescriptors: [sortDescripter], predicate: predicate, sectionNameKeyPath: "occuredAt")
        controller.delegate = self
        
        return controller
    }()
    
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
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print(error)
        }
        
        let month = currentSelectedDate.month
        
        // 今日の月のコレクションセルを探し、中央に表示して選択状態にする
        selectedDateCellIndexPath = IndexPath(row: month - 1, section: 0)
        dateCollectionView.scrollToItem(at: selectedDateCellIndexPath, at: .centeredHorizontally, animated: false)
        
    }
    
    private func getMonthRange(date: Date) -> [String: Date]{
        let year = currentSelectedDate.year
        let month = currentSelectedDate.month
        
        let from = DatetimeUtil.formattedDateToDate(strDate: "\(year)年\(month)月1日")
        var to: Date
        
        if month != 12 {
            to = DatetimeUtil.formattedDateToDate(strDate: "\(year)年\(month + 1)月1日")
        }
        else{
            to = DatetimeUtil.formattedDateToDate(strDate: "\(year + 1)年1月1日")
        }
        
        return ["from": from, "to": to]
        
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
            let result = getMonthRange(date: currentSelectedDate)
            let from = result["from"]!
            let to = result["to"]!
            do {
                fetchedResultsController.fetchRequest.predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@) AND (isRegistered <> 'false')", from as CVarArg, to as CVarArg)
                try fetchedResultsController.performFetch()
            }
            catch {
                print(error)
            }
            tvTransactionList.reloadData()
        }
    }
}

extension TransactionListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController.sections else {return 0}
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = fetchedResultsController.sections else {return ""}
        
        let sectionName = sections[section].name
        let charloc = sectionName[...sectionName.range(of: " ")!.lowerBound]
        
        let returnValue = String(charloc)
        
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tvTransactionList.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        
        if let cell = cell as? TransactionCell {
            let expense = fetchedResultsController.object(at: indexPath)
            cell.setupCell(expense: expense)
        }
        
        return cell
    }
    
}

extension TransactionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tvTransactionList.cellForRow(at: indexPath)
        
        if let cell = cell as? TransactionCell {
            
            let detailedReceitViewController = DetailedExpenseViewController.getInitialViewController(expense: cell.getExpense())
            present(detailedReceitViewController, animated: true, completion: nil)
        }
    }
}

extension TransactionListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 50)
    }
    
}

extension TransactionListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tvTransactionList.insertRows(at: [indexPath!], with: .automatic)
        case .delete:
            tvTransactionList.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tvTransactionList.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tvTransactionList.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default:
            break;
        }
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvTransactionList.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tvTransactionList.endUpdates()
    }
}
