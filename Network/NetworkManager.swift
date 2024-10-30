//
//  NetworkManager.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import Foundation

// MARK: - Constants
struct Constants {
    static let api_key = "jlK%2B0ig7iLAbdOuTJsnkp6n0RdeEMtGKsw53jEMbKm3PcB7NFTSeUrnXixogiuvNtHQXeqxgV88buRZvTjG73w%3D%3D"
    static let base_URL = "https://apis.data.go.kr/B551011/KorService1"
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    /// 지역기반 관광정보를 받아오는 함수
    func getAreaBasedList(pageNo: String = "1", contentTypeId: String = "12", cat1: String, cat2: String, cat3: String, completion: @escaping (Result<AttractionResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.base_URL)/areaBasedList1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: "5"),
            URLQueryItem(name: "pageNo", value: pageNo),
            URLQueryItem(name: "MobileOS", value: "iOS"),
            URLQueryItem(name: "MobileApp", value: "takeTrip"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "listYN", value: "Y"),
            URLQueryItem(name: "arrange", value: "Q"),  // "Q"로 변경
            URLQueryItem(name: "contentTypeId", value: contentTypeId),
            URLQueryItem(name: "cat1", value: cat1),   // 추가된 cat1 파라미터
            URLQueryItem(name: "cat2", value: cat2), // 추가된 cat2 파라미터
            URLQueryItem(name: "cat3", value: cat3) // 추가된 cat3 파라미터
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return completion(.failure(error!))
            }
            
            do {
                let results = try JSONDecoder().decode(AttractionResponse.self, from: data)
                completion(.success(results))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    // contentId를 통해 이미지를 불러오는 함수
    func getSpotImage(contentId: String, completion: @escaping (Result<AttractionImagesResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.base_URL)/detailImage1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "contentId", value: contentId),
            URLQueryItem(name: "imageYN", value: "Y"),
            URLQueryItem(name: "subImageYN", value: "Y"),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "pageNo", value: "1")
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                    print("error 발생 1")
                }
                return
            }
            
            do {
                
                let results = try JSONDecoder().decode(AttractionImagesResponse.self, from: data)
                // 안전하게 items를 언래핑하고 nil일 경우 빈 배열 반환
                completion(.success(results))
                
            } catch {
                completion(.failure(error))
                print("error 발생 2")
            }
        }
        task.resume()
    }
    
    
    /// contentId를 통해 명소의 운영시간, 휴무일 등에 대한 정보를 얻어오는 함수 
    func getDetailIntro(contentId: String, contentTypeId: String, completion: @escaping (Result<UnifiedResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.base_URL)/detailIntro1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "MobileOS", value: "iOS"),
            URLQueryItem(name: "MobileApp", value: "takeTrip"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "contentId", value: contentId),
            URLQueryItem(name: "contentTypeId", value: contentTypeId),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "pageNo", value: "1")
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return completion(.failure(error!))
            }
            
            do {
                let results = try JSONDecoder().decode(UnifiedResponse.self, from: data)
                completion(.success(results))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    /// contentId를 통해 외부 API 정보를 통해 해당 소개 글 받아오는 함수
    func getCommonData(contentId: String, contentTypeId: String, completion: @escaping (Result<AttractionResponse, Error>) -> Void) {
        
        var components = URLComponents(string: "\(Constants.base_URL)/detailCommon1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "MobileOS", value: "IOS"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "contentId", value: contentId),
            URLQueryItem(name: "contentTypeId", value: contentTypeId),
            URLQueryItem(name: "defaultYN", value: "Y"),
            URLQueryItem(name: "firstImageYN", value: "Y"),
            URLQueryItem(name: "areacodeYN", value: "Y"),
            URLQueryItem(name: "catcodeYN", value: "Y"),
            URLQueryItem(name: "addrinfoYN", value: "Y"),
            URLQueryItem(name: "mapinfoYN", value: "Y"),
            URLQueryItem(name: "overviewYN", value: "Y"),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "pageNo", value: "1") // 페이지 번호를 기본값으로 설정
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                if let error = error {
                    completion(.failure(error))
                    
                    print("error 발생 1")
                }
                return
            }
            
            do {
                let results = try JSONDecoder().decode(AttractionResponse.self, from: data)
                completion(.success(results))
                
            } catch let jsonError {
                completion(.failure(jsonError))
                print("JSON 디코딩 에러: \(jsonError.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func getLocationBasedList(
        pageNo: String = "1",
        numOfRows: String = "9",
        mapX: String,
        mapY: String,
        radius: String = "1000",
        completion: @escaping (Result<AttractionResponse, Error>) -> Void
    ) {
        // URLComponents 생성
        var components = URLComponents(string: "\(Constants.base_URL)/locationBasedList1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: numOfRows),
            URLQueryItem(name: "pageNo", value: pageNo),
            URLQueryItem(name: "MobileOS", value: "iOS"),
            URLQueryItem(name: "MobileApp", value: "takeTrip"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "listYN", value: "Y"),
            URLQueryItem(name: "arrange", value: "Q"),  // 
            URLQueryItem(name: "mapX", value: mapX),    // 위도 좌표
            URLQueryItem(name: "mapY", value: mapY),    // 경도 좌표
            URLQueryItem(name: "radius", value: radius) // 검색 반경
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return completion(.failure(error!))
            }
            
            do {
                let results = try JSONDecoder().decode(AttractionResponse.self, from: data)
                completion(.success(results))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    /// 키워드를 가지고 결과를 보여주는 함수
    func searchKeywordList(pageNo: String = "1", keyword: String, completion: @escaping (Result<AttractionResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.base_URL)/searchKeyword1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "pageNo", value: pageNo),
            URLQueryItem(name: "MobileOS", value: "iOS"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "_type", value: "json"),
            URLQueryItem(name: "listYN", value: "Y"),
            URLQueryItem(name: "arrange", value: "Q"),
            URLQueryItem(name: "keyword", value: keyword) // 검색 키워드
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return completion(.failure(error!))
            }
            
            do {
                let results = try JSONDecoder().decode(AttractionResponse.self, from: data)
                completion(.success(results))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    func fetchCategoryCode(contentTypeId: String, cat1: String, cat2: String, cat3: String, pageNo: String = "1", completion: @escaping (Result<AttractionResponse, Error>) -> Void) {
        var components = URLComponents(string: "\(Constants.base_URL)/categoryCode1")
        
        // 쿼리 아이템 설정
        components?.queryItems = [
            URLQueryItem(name: "serviceKey", value: Constants.api_key),
            URLQueryItem(name: "numOfRows", value: "10"),
            URLQueryItem(name: "pageNo", value: pageNo),
            URLQueryItem(name: "MobileOS", value: "ETC"),
            URLQueryItem(name: "MobileApp", value: "AppTest"),
            URLQueryItem(name: "contentTypeId", value: contentTypeId),
            URLQueryItem(name: "cat1", value: cat1),
            URLQueryItem(name: "cat2", value: cat2),
            URLQueryItem(name: "cat3", value: cat3),
            URLQueryItem(name: "_type", value: "json")
        ]
        
        // 퍼센트 인코딩 후 "+"를 "%2B"로 대체
        if let encodedQuery = components?.percentEncodedQuery?.replacingOccurrences(of: "%25", with: "%") {
            components?.percentEncodedQuery = encodedQuery
        }
        
        // URL 생성
        guard let url = components?.url else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                print("Network error: \(String(describing: error))")
                return completion(.failure(error!))
            }
            
            do {
                let results = try JSONDecoder().decode(AttractionResponse.self, from: data)
                completion(.success(results))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
}
