//
//  UnifiedResponse.swift
//  takeTrip
//
//  Created by 권정근 on 10/21/24.
//


import Foundation

// 통합된 모델 구조
struct UnifiedResponse: Codable {
    let response: UnifiedInfoResponse
}

struct UnifiedInfoResponse: Codable {
    let header: InfoResponseHeader
    let body: InfoResponseBody
}

struct InfoResponseHeader: Codable {
    let resultCode: String
    let resultMsg: String
}

struct InfoResponseBody: Codable {
    let items: InfoItems?
    let numOfRows: Int
    let pageNo: Int
    let totalCount: Int
}

struct InfoItems: Codable {
    let item: [InfoItem]?
}

// 통합된 InfoItem 모델
struct InfoItem: Codable {
    let contentid: String
    let contenttypeid: String
    
    // 공통 필드들
    let infocenter: String?
    let restdate: String?
    let usetime: String?
    let parking: String?
    
    // 음식 관련 필드들 (contentTypeId = "39")
    let firstmenu: String?
    let treatmenu: String?
    let opentimefood: String?
    let restdatefood: String?
    let chkcreditcardfood: String?
    let parkingfood: String?
    let infocenterfood: String?
    
    // 관광지 관련 필드들 (contentTypeId = "12")
    let heritage1: String?
    let heritage2: String?
    let heritage3: String?
    
    // 쇼핑 관련 필드들 (contentTypeId = "38")
    let saleitem: String?
    let saleitemcost: String?
    let shopguide: String?
    let scaleshopping: String?
    let restdateshopping: String?
    let parkingshopping: String?
    let chkbabycarriageshopping: String?
    let chkpetshopping: String?
    let chkcreditcardshopping: String?
    let opentime: String?
    let infocentershopping: String?
    
    // 문화시설 관련 필드들 (contentTypeId = "14")
    let scale: String?
    let usefee: String?
    let spendtime: String?
    let parkingfee: String?
    let infocenterculture: String?
    let accomcountculture: String?
    let usetimeculture: String?
    let restdateculture: String?
    let parkingculture: String?
    let chkbabycarriageculture: String?
    let chkpetculture: String?
    let chkcreditcardculture: String?
    
    // 관광코스 관련 필드들 (contentTypeId = "25")
    let distance: String?
    let schedule: String?
    let taketime: String?
    let theme: String?
    
    
    // 통합된 영업시간 필드 반환 (계산 프로퍼티)
    var operatingTime: String? {
        switch contenttypeid {
        case "12":
            return usetime
        case "14":
            return usetimeculture
        case "38":
            return opentime
        case "39":
            return opentimefood
        default:
            return nil
        }
    }
    
    // 통합된 휴무일 필드 반환 (계산 프로퍼티)
    var restDate: String? {
        switch contenttypeid {
        case "12":
            return restdate
        case "14":
            return restdateculture
        case "38":
            return restdateshopping
        case "39":
            return restdatefood
        default:
            return nil
        }
    }
    
    // 통합된 주차 필드 반환 (계산 프로퍼티)
    var parkingLot: String? {
        switch contenttypeid {
        case "12":
            return parking
        case "14":
            return parkingculture
        case "38":
            return parkingshopping
        case "39":
            return parkingfood
        default:
            return nil
        }
    }
    
    // 통합된 전화번호 필드 반환 (계산 프로퍼티)
    var phoneNumber: String? {
        switch contenttypeid {
        case "12":
            return infocenter
        case "14":
            return infocenterculture
        case "38":
            return infocentershopping
        case "39":
            return infocenterfood
        default:
            return nil
        }
    }
}
