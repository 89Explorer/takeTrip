//
//  FeedStorageManager.swift
//  takeTrip
//
//  Created by 권정근 on 11/12/24.
//

/*
 FileManager를 통해 이미지를 저장하고 해당 이미지 파일 경로를 반환하는 메서드를 작성
 */

import UIKit

class FeedStorageManager {
    
    // Documents 폴더 경로 가져오기
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    // 이미지 저장
    func saveImages(images: [UIImage], feedID: String) -> [String] {
        let feedFolder = getDocumentsDirectory().appendingPathComponent(feedID)
        
        // 폴더가 없으면 생성
        if !FileManager.default.fileExists(atPath: feedFolder.path) {
            try? FileManager.default.createDirectory(at: feedFolder, withIntermediateDirectories: true, attributes: nil)
        }
        
        var savedImagePaths: [String] = []
        
        for image in images {
            let imageID = UUID().uuidString // 각 이미지의 고유 ID 생성
            let fileName = "\(imageID).jpg"
            let fileURL = feedFolder.appendingPathComponent(fileName)
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                try? imageData.write(to: fileURL)
                savedImagePaths.append("\(feedID)/\(fileName)") // 상대경로 저장
            }
        }
        
        return savedImagePaths
    }

    // 이미지 로드
    func loadImages(from relativePaths: [String]) -> [UIImage] {
        var images = [UIImage]()
        
        for relativePath in relativePaths {
            let fullPath = getDocumentsDirectory().appendingPathComponent(relativePath)
            if let image = UIImage(contentsOfFile: fullPath.path) {
                images.append(image)
            }
        }
//        print("불러온 이미지", images)
        return images
    }
    
    
    // 이미지 삭제
    func deleteImages(from paths: [String]) {
        for path in paths {
            let fileURL = getDocumentsDirectory().appendingPathComponent(path)
            try? FileManager.default.removeItem(at: fileURL)
        }
    }
}
