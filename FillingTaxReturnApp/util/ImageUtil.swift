//
//  ImageUtil.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/06/06.
//

import Foundation
import UIKit

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
    
    class func getEmptyImage(color: UIColor, size: CGSize, imageView:UIImageView) -> UIImage {
        // グラフィックスコンテキストを作成
        UIGraphicsBeginImageContext(size)

        // グラフィックスコンテキスト用の位置情報
        let rect = imageView.frame
        // グラフィックスコンテキストを取得
        let context = UIGraphicsGetCurrentContext()
        // グラフィックスコンテキストの設定
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        // グラフィックスコンテキストの画像を取得
        let image = UIGraphicsGetImageFromCurrentImageContext()!

        // グラフィックスコンテキストの編集を終了
        UIGraphicsEndImageContext()

        return image
   }

}
