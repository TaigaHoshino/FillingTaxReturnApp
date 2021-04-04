//
//  ReadAndWriteImageUtil.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/24.
//

import Foundation
import UIKit

class ReadAndWriteFileUtil {
    static func getImageInDocumentsDirectory(filename: String) -> String?{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        let fileURL = documentsURL.appendingPathComponent(filename)
        return fileURL?.path
    }
    
    static func saveImage (image: UIImage, path: String ) -> Bool {
        do {
            try image.jpegData(compressionQuality: 1.0)!.write(to: URL(fileURLWithPath: "\(path).jpg"))
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    static func loadFileFromPath(path: String) -> UIImage?{
        let image = UIImage(contentsOfFile: "\(path).jpg")
        if image == nil{
            print("imageLoadFailed: \(path).jpg")
        }
        return image
    }
    
    static func deleteFileFromPath(path: String) -> Bool{
        let fileManager = FileManager.default
        do{
            try fileManager.removeItem(atPath: "\(path).jpg")
        }
        catch{
            print(error)
            return false
        }
        return true
    }
}
