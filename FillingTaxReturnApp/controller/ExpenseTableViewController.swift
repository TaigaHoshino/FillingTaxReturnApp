//
//  ExpenseTableViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/12.
//

import UIKit
import CoreData

class ExpenseTableViewController: UITableViewController {
    
    private var date: Date!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Expense> = {
        let sortDescripter = NSSortDescriptor(key: "occuredAt", ascending: true)
        
        let result = getMonthRange(date: date)
        let from = result["from"]!
        let to = result["to"]!
        
        let predicate = NSPredicate(format: "(isRegistered == true) AND (occuredAt >= %@) AND (occuredAt < %@)", from as CVarArg, to as CVarArg)
        let controller: NSFetchedResultsController<Expense> = BaseDataModel.getFetchedResultController(sortDescriptors: [sortDescripter], predicate: predicate, sectionNameKeyPath: "occuredAt")
        controller.delegate = self
        
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print(error)
        }
    }
    
    public func setDate(date: Date) {
        
        self.date = date
           
        let result = getMonthRange(date: date)
        let from = result["from"]!
        let to = result["to"]!
        
        do {
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format:"(isRegistered == true) AND (occuredAt >= %@) AND (occuredAt < %@)", from as CVarArg, to as CVarArg)
            try fetchedResultsController.performFetch()
        }
        catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    private func getMonthRange(date: Date) -> [String: Date]{
        let year = date.year
        let month = date.month
        
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
    
    public static func getInitialController(date: Date) -> Self {
        let storyboard = UIStoryboard(name: "ExpenseTable", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "ExpenseTableViewController") as! Self
        viewController.date = date
        return viewController
    }
}

extension ExpenseTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController.sections else {return 0}
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sections = fetchedResultsController.sections else {return ""}
        
        let sectionName = sections[section].name
        let date = DatetimeUtil.strDateToDate(strDate: sectionName, format: NSLocalizedString("swiftStrDate", comment: ""))
        let returnValue = DatetimeUtil.dateToStrDate(date: date!, format: String(format: NSLocalizedString("formattedStrDate", comment: ""), "yyyy", "MM", "dd"))
        
        return returnValue
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        
        
        if let cell = cell as? TransactionCell {
            let expense = fetchedResultsController.object(at: indexPath)
            cell.setupCell(expense: expense)
        }
        
        return cell
    }
    
}


extension ExpenseTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let cell = cell as? TransactionCell {
            
            let detailedReceitViewController = DetailedExpenseViewController.getInitialViewController(expense: cell.getExpense())
            present(detailedReceitViewController, animated: true, completion: nil)
        }
    }
}

extension ExpenseTableViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 50)
    }
    
}

extension ExpenseTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [indexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default:
            break;
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
            switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
            default:
                return
            }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
