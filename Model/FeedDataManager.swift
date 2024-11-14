//
//  FeedDataManager.swift
//  takeTrip
//
//  Created by 권정근 on 11/12/24.
//

import CoreData
import UIKit

class FeedDataManager {
    
    static let shared = FeedDataManager()
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let storageManager = FeedStorageManager()
    
    // Core Data에 저장
    func saveFeedItem(feedItem: FeedItem) {
        let feedEntity = FeedEntity(context: context)
        
        // FeedItem의 데이터 설정
        feedEntity.tripLog = feedItem.tripLog
        feedEntity.location = feedItem.location
        feedEntity.date = feedItem.date
        feedEntity.category = feedItem.category
        feedEntity.feedID = feedItem.feedID
        
        // 이미지 저장 및 경로 설정
        if let images = feedItem.images {
            
            let imagePaths = storageManager.saveImages(images: images, feedID: feedItem.feedID)
            feedEntity.imagePaths = imagePaths.joined(separator: ",")
        }
        
        do {
            try context.save()
            print("FeedItem이 성공적으로 저장되었습니다.")
            //print("저장된 이미지 경로:", feedEntity.feedID!)
        } catch {
            print("FeedItem 저장 실패: \(error)")
        }
    }
    
    // Core Data에서 불러오기
    func fetchFeedItems() -> [FeedItem] {
        let request: NSFetchRequest<FeedEntity> = FeedEntity.fetchRequest()
        
        // 날짜를 기준으로 정렬
        let dateOrder = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [dateOrder]
        var feedItems: [FeedItem] = []
        
        do {
            let feedEntities = try context.fetch(request)
            
            for entity in feedEntities {
                
                let images: [UIImage]
                
                if let imagePathsString = entity.imagePaths {
                    let imagePathsArray = imagePathsString.components(separatedBy: ",")
                    images = storageManager.loadImages(from: imagePathsArray)
                } else {
                    images = []
                }
                
                // FeedItem을 생성하고 데이터 할당
                let feedItem = FeedItem(
                    images: images,
                    tripLog: entity.tripLog,
                    location: entity.location,
                    date: entity.date,
                    category: entity.category,
                    feedID: entity.feedID ?? UUID().uuidString
                )
                feedItems.append(feedItem)
                print(feedItem.feedID)
            }
        } catch {
            print("데이터 로드 실패: \(error)")
        }
        
        return feedItems
    }
    
    // Core Data에서 삭제하기
    func deleteFeedItem(feedID: String) {
        let request: NSFetchRequest<FeedEntity> = FeedEntity.fetchRequest()
        request.predicate = NSPredicate(format: "feedID == %@", feedID)

        do {
            let results = try context.fetch(request)
            if let feedEntity = results.first {
                // 이미지 경로 삭제
                if let imagePathsString = feedEntity.imagePaths {
                    let imagePathsArray = imagePathsString.components(separatedBy: ",")
                    storageManager.deleteImages(from: imagePathsArray)
                }
                // Core Data에서 엔티티 삭제
                context.delete(feedEntity)
                try context.save()
                print("FeedItem이 성공적으로 삭제되었습니다.")
            
            }
        } catch {
            print("FeedItem 삭제 실패: \(error)")
        }
    }
}
