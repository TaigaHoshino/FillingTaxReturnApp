//
//  TransactionListCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/05.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbCountingClass: UILabel!
    private var expense: Expense!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(expense: Expense){
        self.expense = expense
        let price = Int(expense.expense)
        self.lbPrice.text = price.addComma()
        self.lbCountingClass.text = Datasets.findCountingClassTitleById(id: Int(expense.countingClass))
    }
    
    func getExpense() -> Expense {
        return expense
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
