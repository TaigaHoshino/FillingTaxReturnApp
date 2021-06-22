//
//  Receipt+CoreDataProperties.swift
//  FillingTaxReturnApp
//
//  Created by 星野大我 on 2021/03/22.
//
//

import Foundation
import CoreData


extension Receipt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Receipt> {
        return NSFetchRequest<Receipt>(entityName: "Receipt")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var imageName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var countingClass: NSNumber?
    @NSManaged public var taxClass: NSNumber?
    @NSManaged public var occuredAt: Date?
    @NSManaged public var expense: NSNumber?
    @NSManaged public var isRegistered: NSNumber?

}

extension Receipt : Identifiable {

}
