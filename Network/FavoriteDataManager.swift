//
//  FavoriteDataManager.swift
//  takeTrip
//
//  Created by 권정근 on 11/19/24.
//

import Foundation
import UIKit
import CoreData


class FavoriteDataManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func addToFavorite(feedID: String) {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "feedID == %@", feedID)
        
        do {
            let existingFavorite = try context.fetch(fetchRequest).first
            
            if existingFavorite == nil {
                let newFavorite = FavoriteEntity(context: context)
                newFavorite.feedID = feedID
                newFavorite.isFavorite = true
                
                try context.save()
                print("Added to favorites: \(feedID)")
            } else {
                print("Already in favorites.")
            }
        } catch {
            print("Failed to add to favorites: \(error)")
        }
    }
    
    func removeFromFavorite(feedID: String) {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "feedID == %@", feedID)
        
        do {
            if let favorite = try context.fetch(fetchRequest).first {
                context.delete(favorite)
                try context.save()
                print("Removed from favorites: \(feedID)")
            } else {
                print("Favorite not found.")
            }
        } catch {
            print("Failed to remove from favorites: \(error)")
        }
    }

    func isFavorite(feedID: String) -> Bool {
        let fetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "feedID == %@", feedID)
        
        do {
            let favorite = try context.fetch(fetchRequest).first
            return favorite?.isFavorite ?? false
        } catch {
            print("Failed to check favorite status: \(error)")
            return false
        }
    }
    
    func fetchFavoriteFeeds() -> [FeedEntity] {
        let favoriteFetchRequest: NSFetchRequest<FavoriteEntity> = FavoriteEntity.fetchRequest()
        favoriteFetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        
        do {
            let favorites = try context.fetch(favoriteFetchRequest)
            let feedIDs = favorites.map { $0.feedID }
            
            let feedFetchRequest: NSFetchRequest<FeedEntity> = FeedEntity.fetchRequest()
            feedFetchRequest.predicate = NSPredicate(format: "feedID IN %@", feedIDs)
            
            return try context.fetch(feedFetchRequest)
        } catch {
            print("Failed to fetch favorite feeds: \(error)")
            return []
        }
    }
}

