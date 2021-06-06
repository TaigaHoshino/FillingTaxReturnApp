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
    private var receipt: Receipt!
    
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
    
    func setupCell(receipt: Receipt){
        self.receipt = receipt
        let price = receipt.expense as! Int
        self.lbPrice.text = price.addComma()
        self.lbCountingClass.text = ReceiptClassesUtil.findCountingClassTitleById(id: receipt.countingClass as! Int)
    }
    
    func getReceipt() -> Receipt {
        return receipt
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
