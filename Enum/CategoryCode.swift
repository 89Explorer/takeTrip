//
//  CategoryCode.swift
//  takeTrip
//
//  Created by 권정근 on 10/21/24.
//

import Foundation


// 열거형 정의
enum FirstCategory: String {
    
    case nature = "A01"
    case culture = "A02"
    case course = "C01"
    case leisure = "A03"
    
    var displayName: String {
        
        switch self {
        case .nature:
            return "자연"
        case .culture:
            return "인문"
        case .course:
            return "여행코스"
        case .leisure:
            return "레포츠"
        }
    }
}


// MARK: - 중분류 열거형
enum SecondCategory: String {
    
    case natureAttraction = "A0101"
    case AttractionResource = "A0102"
    case historyAttraction = "A0201"
    case touristAttraction = "A0202"
    case experientailAttraction = "A0203"
    case industryAttraction = "A0204"
    case architectureAttraction = "A0205"
    case facilities = "A0206"
    case festival = "A0207"
    case showEvent = "A0208"
    case familyCourse = "C0112"
    case aloneCourse = "C0113"
    case healingCourse = "C0114"
    case walkCourse = "C0115"
    case campingCourse = "C0116"
    case tasteCourse = "C0117"
    case leisureIntro = "A0301"
    case trackLeisure = "A0302"
    case waterLeisure = "A0303"
    case skyLeisure = "A0304"
    case compositeLeisure = "A0305"
    
    var displayName: String {
        
        switch self {
        case .natureAttraction:
            return "자연관광지"
        case .AttractionResource:
            return "관광자원"
        case .historyAttraction:
            return "역사관광지"
        case .touristAttraction:
            return "휴향관광지"
        case .experientailAttraction:
            return "체험관광지"
        case .industryAttraction:
            return "산업관광지"
        case .architectureAttraction:
            return "건축/조형물"
        case .facilities:
            return "문화시설"
        case .festival:
            return "축제"
        case .showEvent:
            return "공연/행사"
        case .familyCourse:
            return "가족코스"
        case .aloneCourse:
            return "나홀로코스"
        case .healingCourse:
            return "힐링코스"
        case .walkCourse:
            return "도보코스"
        case .campingCourse:
            return "캠핑코스"
        case .tasteCourse:
            return "맛코스"
        case .leisureIntro:
            return "레포츠소개"
        case .trackLeisure:
            return "육상 레포츠"
        case .waterLeisure:
            return "수상 레포츠"
        case .skyLeisure:
            return "항공 레포츠"
        case .compositeLeisure:
            return "복합 레포츠"
        }
    }
}


// MARK: - 소분류 열거형
enum ThirdCategory: String {
    
    case naturePark = "A01010100"
    case provincialPark = "A01010200"
    case nationalPark = "A01010300"
    case mountain = "A01010400"
    case naturalTourism = "A01010500"
    case recreationalForest = "A01010600"
    case arboretum = "A01010700"
    case waterFall = "A01010800"
    case valley = "A01010900"
    case mineralSpring = "A01011000"
    case coastalScenicArea = "A01011100"
    case beach = "A01011200"
    case island = "A01011300"
    case harbor = "A01011400"
    case lighthouse = "A01011600"
    case lake = "A01011700"
    case river = "A01011800"
    case cave = "A01011900"
    case spa = "A02020300"
    case bridge = "A02050100"
    case monument = "A02050200"
    case fountain = "A02050300"
    case statue = "A02050400"
    case tunnel = "A02050500"
    case famousBuilding = "A02050600"
    case museum = "A02060100"
    case memorialHall = "A02060200"
    case exhibitionHall = "A02060300"
    case conventionCenter = "A02060400"
    case artGallery = "A02060500"
    case performanceHall = "A02060600"
    case culturalCenter = "A02060700"
    case foreignCulturalCenter = "A02060800"
    case library = "A02060900"
    case largeBookstore = "A02061000"
    case culturalHeritageCenter = "A02061100"
    case cinema = "A02061200"
    case languageSchool = "A02061300"
    case school = "A02061400"
    case culturalFestival = "A02070100"
    case generalFestival = "A02070200"
    case traditionalPerformance = "A02080100"
    case theater = "A02080200"
    case musical = "A02080300"
    case opera = "A02080400"
    case exhibition = "A02080500"
    case expo = "A02080600"
    case dance = "A02080800"
    case classicalConcert = "A02080900"
    case popConcert = "A02081000"
    case movie = "A02081100"
    case sportsEvent = "A02081200"
    case otherEvent = "A02081300"
    case familyCourse = "C01120001"
    case aloneCourse = "C01130001"
    case healingCourse = "C01140001"
    case walkCourse = "C01150001"
    case campingCourse = "C01160001"
    case tasteCourse = "C01170001"
    case waterLeisure = "A03010200"
    case airLeisure = "A03010300"
    case trainingFacilities = "A03020200"
    case stadium = "A03020300"
    case inlineSkating = "A03020400"
    case biking = "A03020500"
    case karting = "A03020600"
    case golf = "A03020700"
    case horseRacing = "A03020800"
    case cycleRacing = "A03020900"
    case casino = "A03021000"
    case horsebackRiding = "A03021100"
    case skiing = "A03021200"
    case skating = "A03021300"
    case sledding = "A03021400"
    case hunting = "A03021500"
    case shootingRange = "A03021600"
    case camping = "A03021700"
    case rockClimbing = "A03021800"
    case survivalGame = "A03022000"
    case atv = "A03022100"
    case mtb = "A03022200"
    case offRoad = "A03022300"
    case bungeeJumping = "A03022400"
    case skiRentalShop = "A03022600"
    case trekking = "A03022700"
    case windsurfing = "A03030100"
    case kayaking = "A03030200"
    case yachting = "A03030300"
    case snorkeling = "A03030400"
    case freshwaterFishing = "A03030500"
    case seaFishing = "A03030600"
    case swimming = "A03030700"
    case rafting = "A03030800"
    case skydiving = "A03040100"
    case ultralightFlying = "A03040200"
    case hangGliding = "A03040300"
    case hotAirBalloon = "A03040400"
    case complexLeisure = "A03050100"
    case themaPark = "A02020600"
    case placeMarket = "A04010200"
    
    
    var displayName: String {
        
        switch self {
        case .naturePark:
            return "국립공원"
        case .provincialPark:
            return "도립공원"
        case .nationalPark:
            return "국립공원"
        case .mountain:
            return "산"
        case .naturalTourism:
            return "자연생태관광지"
        case .recreationalForest:
            return "자연휴양림"
        case .arboretum:
            return "수목원"
        case .waterFall:
            return "폭포"
        case .valley:
            return "계곡"
        case .mineralSpring:
            return "약수터"
        case .coastalScenicArea:
            return "해안절경"
        case .beach:
            return "해수욕장"
        case .island:
            return "섬"
        case .harbor:
            return "항구/포구"
        case .lighthouse:
            return "등대"
        case .lake:
            return "호수"
        case .river:
            return "강"
        case .cave:
            return "동굴"
        case .bridge:
            return "다리/대교"
        case .monument:
            return "기념탑/기념비/전망대"
        case .fountain:
            return "분수"
        case .statue:
            return "동상"
        case .tunnel:
            return "터널"
        case .famousBuilding:
            return "유명건물"
        case .museum:
            return "박물관"
        case .memorialHall:
            return "기념관"
        case .exhibitionHall:
            return "전시관"
        case .conventionCenter:
            return "컨벤션센터"
        case .artGallery:
            return "미술관/화랑"
        case .performanceHall:
            return "공연장"
        case .culturalCenter:
            return "문화원"
        case .foreignCulturalCenter:
            return "외국문화원"
        case .library:
            return "도서관"
        case .largeBookstore:
            return "대형서점"
        case .culturalHeritageCenter:
            return "문화전수시설"
        case .cinema:
            return "영화관"
        case .languageSchool:
            return "어학당"
        case .school:
            return "학교"
        case .culturalFestival:
            return "문화관광축제"
        case .generalFestival:
            return "일반축제"
        case .traditionalPerformance:
            return "전통공연"
        case .theater:
            return "연극"
        case .musical:
            return "뮤지컬"
        case .opera:
            return "오페라"
        case .exhibition:
            return "전시회"
        case .expo:
            return "박람회"
        case .dance:
            return "무용"
        case .classicalConcert:
            return "클래식음악회"
        case .popConcert:
            return "대중콘서트"
        case .movie:
            return "영화"
        case .sportsEvent:
            return "스포츠경기"
        case .otherEvent:
            return "기타행사"
        case .familyCourse:
            return "가족코스"
        case .aloneCourse:
            return "나홀로코스"
        case .healingCourse:
            return "힐링코스"
        case .walkCourse:
            return "도보코스"
        case .campingCourse:
            return "캠핑코스"
        case .tasteCourse:
            return "맛코스"
        case .waterLeisure:
            return "수상레포츠"
        case .airLeisure:
            return "항공레포츠"
        case .trainingFacilities:
            return "수련시설"
        case .stadium:
            return "경기장"
        case .inlineSkating:
            return "인라인(실내 인라인 포함)"
        case .biking:
            return "자전거하이킹"
        case .karting:
            return "카트"
        case .golf:
            return "골프"
        case .horseRacing:
            return "경마"
        case .cycleRacing:
            return "경륜"
        case .casino:
            return "카지노"
        case .horsebackRiding:
            return "승마"
        case .skiing:
            return "스키/스노보드"
        case .skating:
            return "스케이트"
        case .sledding:
            return "썰매장"
        case .hunting:
            return "수렵장"
        case .shootingRange:
            return "사격장"
        case .camping:
            return "야영장,오토캠핑장"
        case .rockClimbing:
            return "암벽등반"
        case .survivalGame:
            return "서바이벌게임"
        case .atv:
            return "ATV"
        case .mtb:
            return "MTB"
        case .offRoad:
            return "오프로드"
        case .bungeeJumping:
            return "번지점프"
        case .skiRentalShop:
            return "스키(보드) 렌탈샵"
        case .trekking:
            return "트래킹"
        case .windsurfing:
            return "윈드서핑/제트스키"
        case .kayaking:
            return "카약/카누"
        case .yachting:
            return "요트"
        case .snorkeling:
            return "스노쿨링/스킨스쿠버다이빙"
        case .freshwaterFishing:
            return "민물낚시"
        case .seaFishing:
            return "바다낚시"
        case .swimming:
            return "수영"
        case .rafting:
            return "래프팅"
        case .skydiving:
            return "스카이다이빙"
        case .ultralightFlying:
            return "초경량비행"
        case .hangGliding:
            return "헹글라이딩/패러글라이딩"
        case .hotAirBalloon:
            return "열기구"
        case .complexLeisure:
            return "복합 레포츠"
        case .spa:
            return "온천/욕장/스파"
        case .themaPark:
            return "테마공원"
        case .placeMarket:
            return "상설시장"
        }
    }
}



