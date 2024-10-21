//
//  AttractionImagesResponse.swift
//  takeTrip
//
//  Created by 권정근 on 10/21/24.
//

import Foundation


// MARK: - Main Response Model
struct AttractionImagesResponse: Codable {
    let response: ImageResponseBody
}

struct ImageResponseBody: Codable {
    let header: ImageResponseHeader
    let body: ImageResponseBodyContent
}

struct ImageResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

// items가 빈문자열 형태 ("") 일 경우를 대비하기 위해 수정 코드
struct ImageResponseBodyContent: Codable {
    let items: ImageItems?
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
    
    // 커스텀 디코딩 로직 추가
    // JSON에서 어떤 키들이 이 모델의 각 프로퍼티와 연결되는지 정의
    enum CodingKeys: String, CodingKey {
        case items, numOfRows, pageNo, totalCount
    }
    
    // 기본적으로 Codable은 자동으로 JSON을 디코딩하지만, 여기서는 items가 빈 문자열일 때 이를 nil로 바꾸는
    // 특별한 처리가 필요해서 직접 디코딩
    init(from decoder: Decoder) throws {
        
        // container를 생성, 이 곳에 JSON 데이터를 담는다.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // 만약에 numOfRows를 numberOfRows 바꾸었다면, 여기서는 바뀐 이름으로 할 것
        // numOfRows, pageNo, totalCount는 그냥 Int 값이기 때문에 기본적인 방법으로 디코딩
        numOfRows = try container.decode(Int.self, forKey: .numOfRows)
        pageNo = try container.decode(Int.self, forKey: .pageNo)
        totalCount = try container.decode(Int.self, forKey: .totalCount)
        
        // items를 빈 문자열인 경우 nil로 처리
        if let itemsString = try? container.decode(String.self, forKey: .items), itemsString.isEmpty {
            items = nil
        } else {
            items = try? container.decode(ImageItems.self, forKey: .items)
        }
    }
}

struct ImageItems: Codable {
    let item: [ImageItem]?
}

// MARK: - Image Item Model
struct ImageItem: Codable {
    let contentid: String
    let originimgurl: String
    let imgname: String
    let smallimageurl: String
    let cpyrhtDivCd: String
    let serialnum: String
}
