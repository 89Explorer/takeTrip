//
//  FavoriteEntity+CoreDataProperties.swift
//  takeTrip
//
//  Created by 권정근 on 11/19/24.
//
//

import Foundation
import CoreData


extension FavoriteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteEntity> {
        return NSFetchRequest<FavoriteEntity>(entityName: "FavoriteEntity")
    }

    @NSManaged public var feedID: String?
    @NSManaged public var isFavorite: Bool

}

extension FavoriteEntity : Identifiable {

}
