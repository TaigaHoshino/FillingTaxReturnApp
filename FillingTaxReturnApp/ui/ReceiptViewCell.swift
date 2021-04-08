//
//  ReceiptViewCell.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/04/02.
//

import UIKit

class ReceiptViewCell: UICollectionViewCell {
    
    @IBOutlet weak var createdAtText: UILabel!
    @IBOutlet weak var uiReceiptImageView: UIImageView!
    @IBOutlet weak var uiRegisterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibViewSet()
      }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.xibViewSet()
    }

    internal func xibViewSet() {
//        if let view = Bundle.main.loadNibNamed("ReceiptViewCell", owner: self, options: nil)?.first as? UIView {
//          view.frame = self.bounds
//        self.backgroundColor = .lightGray
//          self.addSubview(view)
//        }
    }
    
    func setupCell(receipt: Receipt){
        
        DispatchQueue.global().async{
            let targetFile: String! = ReadAndWriteFileUtil.getImageInDocumentsDirectory(filename: receipt.imageName!)
            let img = ReadAndWriteFileUtil.loadFileFromPath(path: targetFile)!.resize(withPercentage: 0.1)
            DispatchQueue.main.async {
                self.uiReceiptImageView.image = img?.resize(size: self.frame.size)
                self.createdAtText.text = DatetimeUtil.dateToFormattedDateTime(date: receipt.createdAt!)
                self.uiRegisterImageView.image = UIImage(named: "baseline_check_circle_outline")
            }
        }
        backgroundColor = .lightGray
    }


}

extension UIImage{
    func resize(size _size: CGSize) -> UIImage? {
        
        let heightRatio = _size.height / size.height
        let widthRatio = _size.width / size.width
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio

        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)

        UIGraphicsBeginImageContext(resizedSize)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
    
    func resize(withPercentage percentage: CGFloat) -> UIImage? {
        
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func fixedOrientation() -> UIImage {
//        if self.imageOrientation == .up { return self }

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
