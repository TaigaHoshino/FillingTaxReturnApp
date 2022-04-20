//
//  IncomeTableViewController.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/17.
//

import UIKit
import CoreData

class IncomeTableViewController: UITableViewController {
    
    private var date: Date!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Income> = {
        let sortDescripter = NSSortDescriptor(key: "occuredAt", ascending: true)
        
        let result = getMonthRange(date: date)
        let from = result["from"]!
        let to = result["to"]!
        
        let predicate = NSPredicate(format: "(occuredAt >= %@) AND (occuredAt < %@)", from as CVarArg, to as CVarArg)
        let controller = IncomeDataModel.getFetchedResultController(sortDescriptors: [sortDescripter], predicate: predicate, sectionNameKeyPath: "occuredAt")
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
            fetchedResultsController.fetchRequest.predicate = NSPredicate(format:"(occuredAt >= %@) AND (occuredAt < %@)", from as CVarArg, to as CVarArg)
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
        
        let from = DatetimeUtil.strDateToDate(strDate: String(format: NSLocalizedString("formattedStrDate", comment: ""), String(year), String(month), "1"),
                                              format: String(format: NSLocalizedString("formattedStrDate", comment: ""), "yyyy", "MM", "dd"))!
        var to: Date
        
        if month != 12 {
            to = DatetimeUtil.strDateToDate(strDate: String(format: NSLocalizedString("formattedStrDate", comment: ""), String(year), String(month+1), "1"),
                                                  format: String(format: NSLocalizedString("formattedStrDate", comment: ""), "yyyy", "MM", "dd"))!
        }
        else{
            to = DatetimeUtil.strDateToDate(strDate: String(format: NSLocalizedString("formattedStrDate", comment: ""), String(year+1), "1", "1"),
                                            format: String(format: NSLocalizedString("formattedStrDate", comment: ""), "yyyy", "MM", "dd"))!
        }
        
        return ["from": from, "to": to]
        
    }
    
    public static func getInitialController(date: Date) -> Self {
        let storyboard = UIStoryboard(name: "IncomeTable", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "IncomeTableViewController") as! Self
        viewController.date = date
        return viewController
    }
}

extension IncomeTableViewController {
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "IncomeCell", for: indexPath)
        
        if let cell = cell as? IncomeTableCell {
            let income = fetchedResultsController.object(at: indexPath)
            cell.setupCell(income: income)
        }
        
        return cell
    }
    
}


extension IncomeTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if let cell = cell as? IncomeTableCell {
            
            let editIncomeViewController = EditDetailedIncomeViewController.getInitialController(income: cell.income)
            present(editIncomeViewController, animated: true, completion: nil)
        }
    }
}

extension IncomeTableViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 80, height: 50)
    }
    
}

extension IncomeTableViewController: NSFetchedResultsControllerDelegate {
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
