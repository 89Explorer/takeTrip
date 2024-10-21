//
//  AttractionResponse.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import Foundation

// MARK: - APIResponse

struct AttractionResponse: Codable {
    let response: Response
}

struct Response: Codable {
    let header: ResponseHeader
    let body: ResponseBody
}

// MARK: - ResponseHeader
struct ResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

// MARK: - ResponseBody
struct ResponseBody: Codable {
    let items: Items
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

// MARK: - Items
struct Items: Codable {
    let item: [AttractionItem]
}

// MARK: - AttractionItem
struct AttractionItem: Codable {
    let addr1: String
    let addr2: String?
    let areacode: String
    let booktour: String?
    let cat1: String
    let cat2: String
    let cat3: String
    let contentid: String
    let contenttypeid: String
    let createdtime: String
    let firstimage: String?
    let firstimage2: String?
    let cpyrhtDivCd: String?
    let mapx: String
    let mapy: String
    let mlevel: String
    let modifiedtime: String
    let sigungucode: String
    let tel: String?
    let telname: String?
    let homepage: String?
    let title: String?
    let zipcode: String?
    let overview: String?
    
    let dist: String?
}




