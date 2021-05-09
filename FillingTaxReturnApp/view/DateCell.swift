//
//  DateCellTableViewCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/29.
//

import UIKit

class DateCell: UICollectionViewCell {
    
    
    private var date: Date!
    @IBOutlet weak var lbYear: UILabel!
    @IBOutlet weak var lbMonth: UILabel!

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
        lbYear.text = "\(year)年"
        lbMonth.text = "\(month)月"
        
    }
    
    func onSelect(){
        self.backgroundColor = .blue
        lbYear.textColor = .white
        lbMonth.textColor = .white
    }
    
    func setDefault(){
        self.backgroundColor = .white
        lbYear.textColor = .black
        lbMonth.textColor = .black
    }

}
