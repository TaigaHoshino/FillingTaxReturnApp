//
//  DateCellTableViewCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/29.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    @IBOutlet weak var btDate: UIButton!
    private var date: Date!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setupCell(date: Date){
        self.date = date
        let calender = Calendar.current
        
        let year = calender.component(.year, from: date)
        let month = calender.component(.month, from: date)
        
        btDate.titleLabel?.numberOfLines = 0
        btDate.titleLabel?.textAlignment = NSTextAlignment.center
        btDate.titleLabel?.baselineAdjustment = .alignCenters
        btDate.setTitle("\(year)年\n\(month)月", for: .normal)
    }

}
