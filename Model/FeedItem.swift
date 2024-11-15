//
//  FeedItem.swift
//  takeTrip
//
//  Created by 권정근 on 11/8/24.
//

import UIKit

struct FeedItem {
    var images: [UIImage]?
    var tripLog: String?
    
    var location: String?
    var date: Date?
    var category: String?
    var feedID: String = UUID().uuidString  // 기본값으로 고유 ID 생성
    var favorite: Bool = false
}
