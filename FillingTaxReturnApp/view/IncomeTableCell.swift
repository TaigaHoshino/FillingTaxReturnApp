//
//  IncomeTableCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/09/17.
//

import UIKit

class IncomeTableCell: UITableViewCell {
    
    private var _income: Income!
    public var income: Income{
        get{
            return _income
        }
    }
    @IBOutlet weak var countingClass: UILabel!
    @IBOutlet weak var price: UILabel!
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setupCell(income: Income) {
        self._income = income
        self.countingClass.text = Datasets.findIncomeClassById(id: Int(_income.countingClass))!["title"] as? String
        self.price.text = Int(income.money).addComma()
    }

}
