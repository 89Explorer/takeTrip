//
//  FeedEntity+CoreDataProperties.swift
//  takeTrip
//
//  Created by 권정근 on 11/12/24.
//
//

import Foundation
import CoreData
import UIKit


extension FeedEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FeedEntity> {
        return NSFetchRequest<FeedEntity>(entityName: "FeedEntity")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var imagePaths: String?
    @NSManaged public var tripLog: String?
    @NSManaged public var location: String?
    @NSManaged public var date: Date?
    @NSManaged public var category: String?
    @NSManaged public var feedID: String?

}

extension FeedEntity : Identifiable {

}
