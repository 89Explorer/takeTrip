//
//  SearchViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Variables
    var spotResults: [AttractionItem] = []
    
    // MARK: - UI Components
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "어디 가실지 장소를 검색하세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        configureConstraints()
        configureNavigationItem()
        
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(searchBar)
        
        let searchBarConstraints = [
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(searchBarConstraints)
    }
    
    
    // MARK: - Functions
    /// 네비게이션 아이템 설정 함수
    func configureNavigationItem() {
        
        let titleLabel = UILabel()
        titleLabel.text = "Search"
        titleLabel.textColor = .label
        // titleLabel.font = UIFont(name: "YeongdoOTF-Bold", size: 28)
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    
    // 사용자가 서치 버트을 눌렀을 때 호출되는 함수
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            print("검색어가 비어있습니다.")
            return
        }
        
        // 입력된 검색어를 콘솔에 출력
        //print("사용자가 입력한 검색어: \(query)")
        
        // 검색어에 맞는 결과를 찾아서 SearchResultsViewController로 전달
        let filteredResults = ["어린이 공원", "어린이 박물관", "어린이 도서관", "키즈카페 어린이"]
        
        // SearchResultsViewController 인스턴스 생성
        let resultsViewController = SearchResultsViewController()
        resultsViewController.updateTableView(with: filteredResults)
        
        navigationController?.pushViewController(resultsViewController, animated: true)
        // 외부 API 호출을 이 부분에서 처러
    }
}
