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
    var spotResultsByContentTypeId: [String: [AttractionItem]] = [:]   // contentTypeId별로 데이터 저장
    var showAllItems: Set<String> = []  // 더 보기를 누른 contentTypeId를 저장
    /// 중복을 확인하기 위한 Set
    var uniqueContentIds = Set<String>()
    
    
    // MARK: - UI Components
    /// 검색어를 입력할 서치바 생성
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "키워드를 입력해주세요"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    /// 검색한 결과를 보여줄 테이블뷰 생성
    let spotResultsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isHidden = true  // 초기에는 테이블뷰를 숨깁니다.
        tableView.allowsSelection = true
        return tableView
    }()
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        
        configureConstraints()
        configureNavigationItem()
        configureTableView()
        configureSearchBarTextField()
        //keyBoardDown()
        
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(searchBar)
        view.addSubview(spotResultsTableView)
        
        NSLayoutConstraint.activate([
            
            // 서치바 레이아웃 설정
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // 결과를 보여주는 테이블 레이아웃 설정 (서치바 바로 아래)
            spotResultsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spotResultsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spotResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            spotResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
    
    
    // MARK: - Functions
    /// 네비게이션 아이템 설정 함수
    func configureNavigationItem() {
        
        let titleLabel = UILabel()
        titleLabel.text = "Search"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    /// 검색결과를 보여주는 테이블뷰 관련 설정을 하는 함수
    func configureTableView() {
        spotResultsTableView.delegate = self
        spotResultsTableView.dataSource = self
        spotResultsTableView.register(spotResultsTableViewCell.self, forCellReuseIdentifier: spotResultsTableViewCell.identifier)
    }
    
    /// 서치바를 커스텀하여 사용할 수 있도록 하는 함수
    func configureSearchBarTextField() {
        // UITextField appearance 설정
        let searchTextFieldAppearance = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchTextFieldAppearance.backgroundColor = UIColor.systemGray5 // 텍스트 필드 배경색
        searchTextFieldAppearance.layer.cornerRadius = 18 // 라운드 코너
        searchTextFieldAppearance.layer.masksToBounds = true
        searchTextFieldAppearance.textColor = .label// 텍스트 색상
        searchTextFieldAppearance.font = UIFont.systemFont(ofSize: 16) // 폰트 크기
        
        // 커스텀 아이콘 설정
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            let customIcon = UIImage(systemName: "magnifyingglass")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
            let iconView = UIImageView(image: customIcon)
            iconView.tintColor = .black
            iconView.contentMode = .scaleAspectFit // 크기 맞춤 설정
            iconView.frame = CGRect(x: 0, y: 0, width: 25, height: 25) // 아이콘 크기 설정
            
            // leftView에 커스텀 아이콘 적용
            textField.leftView = iconView
            textField.leftViewMode = .always  // 텍스트필드의 eftView가 언제 표시될지를 결정하는 속성
        }
    }
    
    /// 검색어를 갖고 외부API를 통해 데이터를 불러오는 함수
//        func searchForKeyword(with keyword: String) {
//            NetworkManager.shared.searchKeywordList(keyword: keyword) { [weak self] results in
//                switch results {
//                case .success(let items):
//                    let searchList = items.response.body.items.item
//    
//                    DispatchQueue.main.async {
//                        // 검색 결과가 있으면 테이블 뷰를 표시하고 없으면 숨깁니다.
//                        self?.spotResults = searchList
//                        self?.spotResultsTableView.isHidden = searchList.isEmpty
//                        self?.spotResultsTableView.reloadData()
//    
//                    }
//    
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    
//    func searchForKeyword(with keyword: String, page: Int, completion: @escaping (Int) -> Void) {
//        NetworkManager.shared.searchKeywordList(pageNo: String(page) ,keyword: keyword) { [weak self] results in
//            switch results {
//            case .success(let items):
//                let searchList = items.response.body.items.item
//                let totalCount = items.response.body.totalCount
//                self?.categorizeByContentTypeId(searchList)
//                completion(totalCount)
//                
//                DispatchQueue.main.async {
//                    // 검색 결과가 있으면 테이블 뷰를 표시하고 없으면 숨깁니다.
//                    self?.spotResultsTableView.isHidden = searchList.isEmpty
//                    self?.spotResultsTableView.reloadData()
//                    
//                }
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//    
//    func fetchForKeyword(with keyword: String) {
//        searchForKeyword(with: keyword, page: 1) { [weak self] totalCount in
//            guard let self = self else { return }
//            
//            // 전체 페이지 수 계산
//            let itemsPersPage = 10
//            let totalPages = (totalCount / itemsPersPage) + (totalCount % itemsPersPage > 0 ? 1 : 0)
//            
//            var allContentTypesSatisfied = true
//            // 각 contentTypId별 최소 5개 확보
//            for contentTypeId in self.spotResultsByContentTypeId.keys {
//                if (self.spotResultsByContentTypeId[contentTypeId]?.count ?? 0) < 3 {
//                    allContentTypesSatisfied = false
//                    self.ensureMinimumItems(for: contentTypeId, keyword: keyword, currentPage: 1, totalPages: totalPages)
//                }
//            }
//            
//            // 모든 contentTypeId가 조건을 충족한 경우만 reloadData 호출
//            if allContentTypesSatisfied {
//                DispatchQueue.main.async {
//                    self.spotResultsTableView.isHidden = self.spotResultsByContentTypeId.isEmpty
//                    self.spotResultsTableView.reloadData()
//                }
//            }
//        }
//    }
//        
//    func categorizeByContentTypeId(_ items: [AttractionItem]) {
//        // 중복 확인을 위한 Set 생성
//        var uniqueItemsSet = Set<String>() // Set에 고유 식별자로 사용할 id를 저장
//        
//        for item in items {
//            let contentTypeId = item.contenttypeid
//            
//            // 중복 검사: Set에 id가 없는 경우 추가
//            if uniqueItemsSet.insert(item.contentid).inserted {
//                // 중복이 아니므로 딕셔너리에 추가
//                spotResultsByContentTypeId[contentTypeId, default: []].append(item)
//            }
//        }
//    }
//
//    
//    
//    func ensureMinimumItems(for contentTypeId: String, keyword: String, currentPage: Int, totalPages: Int) {
//        // 현재 확보된 데이터 수 확인
//        let itemCount = spotResultsByContentTypeId[contentTypeId]?.count ?? 0
//        
//        
//        // 최소 5개 확보되지 않았고, 다음 페이지가 없는 경우 추가 설정
//        if itemCount < 3, currentPage < totalPages {
//            let nextPage = currentPage + 1
//            searchForKeyword(with: keyword, page: nextPage) { [weak self] _ in
//                self?.ensureMinimumItems(for: contentTypeId, keyword: keyword, currentPage: nextPage, totalPages: totalPages)
//            }
//        } else {
//            DispatchQueue.main.async {
//                //self.spotResultsTableView.reloadData()
//            }
//        }
//    }
    
    func searchForKeyword(with keyword: String, page: Int, completion: @escaping (Int) -> Void) {
        NetworkManager.shared.searchKeywordList(pageNo: String(page), keyword: keyword) { [weak self] results in
            switch results {
            case .success(let items):
                let searchList = items.response.body.items.item
                let totalCount = items.response.body.totalCount
                self?.filterAndCategorizeByContentTypeId(searchList)  // 중복 필터링 및 카테고리화
                completion(totalCount)
                
                DispatchQueue.main.async {
                    self?.spotResultsTableView.isHidden = searchList.isEmpty
                    self?.spotResultsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchForKeyword(with keyword: String) {
        // 검색 시작 시 중복 확인 Set을 초기화
        uniqueContentIds.removeAll()

        searchForKeyword(with: keyword, page: 1) { [weak self] totalCount in
            guard let self = self else { return }
            
            let itemsPerPage = 10
            let totalPages = (totalCount / itemsPerPage) + (totalCount % itemsPerPage > 0 ? 1 : 0)

            var allContentTypesSatisfied = false

            // 각 contentTypeId별 최소 3개 확보
            for contentTypeId in self.spotResultsByContentTypeId.keys {
                if (self.spotResultsByContentTypeId[contentTypeId]?.count ?? 0) < 3 {
                    allContentTypesSatisfied = true
                    self.ensureMinimumItems(for: contentTypeId, keyword: keyword, currentPage: 1, totalPages: totalPages)
                }
            }
            
            if allContentTypesSatisfied {
                DispatchQueue.main.async {
                    self.spotResultsTableView.isHidden = self.spotResultsByContentTypeId.isEmpty
                    self.spotResultsTableView.reloadData()
                }
            }
        }
    }

    /// 기존 데이터와 중복된 contentId를 제외하고 `spotResultsByContentTypeId`에 추가
    func filterAndCategorizeByContentTypeId(_ items: [AttractionItem]) {
        for item in items {
            let contentId = item.contentid
            let contentTypeId = item.contenttypeid
            
            // 중복 검사: Set에 contentId가 없는 경우에만 추가
            if uniqueContentIds.insert(contentId).inserted {
                // 중복이 없으므로 딕셔너리에 추가
                spotResultsByContentTypeId[contentTypeId, default: []].append(item)
            }
        }
    }

    func ensureMinimumItems(for contentTypeId: String, keyword: String, currentPage: Int, totalPages: Int) {
        let itemCount = spotResultsByContentTypeId[contentTypeId]?.count ?? 0

        if itemCount < 3, currentPage < totalPages {
            let nextPage = currentPage + 1
            searchForKeyword(with: keyword, page: nextPage) { [weak self] _ in
                self?.ensureMinimumItems(for: contentTypeId, keyword: keyword, currentPage: nextPage, totalPages: totalPages)
            }
        } else {
            DispatchQueue.main.async {
                self.spotResultsTableView.reloadData()
            }
        }
    }
    
    
    func keyBoardDown() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    /// 빈 화면을 터치할 때 호출되는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate, UITextFieldDelegate {
    
    // 사용자가 서치 버트을 눌렀을 때 호출되는 함수
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else {
            print("검색어가 비어있습니다.")
            return
        }
        
        self.fetchForKeyword(with: query)
        searchBar.resignFirstResponder()
    }
    
    
    // 사용자가 검색어를 변경할 때마다 호출되는 함수
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 검색어가 비어있으면 테이블 뷰를 숨김
        if searchText.isEmpty {
            spotResultsByContentTypeId.removeAll()
            spotResultsTableView.isHidden = true
            spotResultsTableView.reloadData()
        }
    }
    
    
}


// MARK: - UITableViewDelegate, UITableViewDataSource
//extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return spotResults.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        
//        cell.textLabel?.text = spotResults[indexPath.row].title
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("called")
//        let selectedItem = spotResults[indexPath.item]
//        print("selectedItem: \(selectedItem)")
//    }
//}



extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return spotResultsByContentTypeId.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keys = Array(spotResultsByContentTypeId.keys)
        
        // section의 범위 확인
        guard section < keys.count else {
            return 0
        }
        
        let contentTypeId = keys[section]
        let items = spotResultsByContentTypeId[contentTypeId] ?? []
        
        // showAllItems에 따라 표시할 아이템 수 결정
        return showAllItems.contains(contentTypeId) ? items.count : min(items.count, 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: spotResultsTableViewCell.identifier, for: indexPath) as? spotResultsTableViewCell else { return UITableViewCell() }
        
        // indexPath.section의 범위 확인
        let keys = Array(spotResultsByContentTypeId.keys)
        guard indexPath.section < keys.count else {
            cell.textLabel?.text = "" // 기본 텍스트 설정
            return cell
        }
        
        let contentTypeId = keys[indexPath.section]
        let items = spotResultsByContentTypeId[contentTypeId] ?? []
        
        // indexPath.row의 범위 확인
        if indexPath.row < items.count {
            // cell.textLabel?.text = items[indexPath.row].title
            let selectedItem = items[indexPath.row]
            cell.configureSearchData(with: selectedItem)
        } else {
            cell.textLabel?.text = "" // 기본 텍스트 설정
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let contentTypeId = Array(spotResultsByContentTypeId.keys)[section]
        
        switch contentTypeId {
        case "12":
            return "관광지"
        case "14":
            return "문화시설"
        case "15":
            return "축제/공연/행사"
        case "25":
            return "여행코스"
        case "28":
            return "레포츠"
        case "32":
            return "숙박"
        case "38":
            return "쇼핑"
        case "39":
            return "음식점"
        default:
            return "기타"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected at section \(indexPath.section), row \(indexPath.row)")
        
        let keys = Array(spotResultsByContentTypeId.keys)
        guard indexPath.section < keys.count else {
            print("Invalid section index")
            return
        }
        
        let contentTypeId = keys[indexPath.section]
        
        if let items = spotResultsByContentTypeId[contentTypeId], indexPath.row < items.count {
            let selectedItem = items[indexPath.row]
            print("Selected title: \(selectedItem.title ?? "실패")")
            print("selected image: \(selectedItem.firstimage ?? "fill.jpg")")
        } else {
            print("Invalid row index")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
}



