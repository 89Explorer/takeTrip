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
    /// 
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
}
