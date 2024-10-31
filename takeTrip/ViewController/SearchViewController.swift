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
    
    /// 네트워크 요청을 통해 키워드 검색 결과를 가져오는 함수
    func searchForKeyword(with keyword: String, page: Int, completion: @escaping (Int) -> Void) {
        NetworkManager.shared.searchKeywordList(pageNo: String(page), keyword: keyword) { [weak self] results in
            switch results {
            case .success(let items):
                let searchList = items.response.body.items.item
                let totalCount = items.response.body.totalCount
                self?.filterAndCategorizeByContentTypeId(searchList)  // 중복 필터링 및 카테고리화
                completion(totalCount)
                DispatchQueue.main.async {
                    self?.spotResultsTableView.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    /// 검색 결과가 최소 3개 확보될 때까지 페이지를 순차적으로 가져오는 함수
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
//    func filterAndCategorizeByContentTypeId(_ items: [AttractionItem]) {
//        
//        for item in items {
//            let contentId = item.contentid!
//            let contentTypeId = item.contenttypeid!
//            
//            // 중복 검사: Set에 contentId가 없는 경우에만 추가
//            if uniqueContentIds.insert(contentId).inserted {
//                // 중복이 없으므로 딕셔너리에 추가
//                spotResultsByContentTypeId[contentTypeId, default: []].append(item)
//            }
//        }
//    }
    
    func filterAndCategorizeByContentTypeId(_ items: [AttractionItem]) {
        // print("Original items count: \(items.count)")
        
        var uniqueContentIds = Set<String>()
        for item in items {
            // print("Processing item with contentTypeId: \(item.contenttypeid ?? "nil")")
            if let contentTypeId = item.contenttypeid, uniqueContentIds.insert(item.contentid!).inserted {
                spotResultsByContentTypeId[contentTypeId, default: []].append(item)
            }
        }
        DispatchQueue.main.async {
            self.spotResultsTableView.reloadData()
        }
        
        // print("Filtered items by contentTypeId:", spotResultsByContentTypeId)
    }

    /// 각 contentTypeId에 대해 최소 3개의 항목이 확보될 때까지 다음 페이지 데이터를 요청하는 함수
    func ensureMinimumItems(for contentTypeId: String, keyword: String, currentPage: Int, totalPages: Int) {
        let itemCount = spotResultsByContentTypeId[contentTypeId]?.count ?? 0

        if itemCount < 3, currentPage < totalPages {
            let nextPage = currentPage + 1
            searchForKeyword(with: keyword, page: nextPage) { [weak self] _ in
                self?.ensureMinimumItems(for: contentTypeId, keyword: keyword, currentPage: nextPage, totalPages: totalPages)
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
    
    @objc func didTapShowMoreButton( _ sender: UIButton) {
        let section = sender.tag
        let keys = Array(spotResultsByContentTypeId.keys)
        
        guard section < keys.count else { return }
        let contentTypeId = keys[section]
        
        // showAllItems에 포함되어 있으면 제거하고, 없으면 추가
        if showAllItems.contains(contentTypeId) {
            showAllItems.remove(contentTypeId)
        } else {
            showAllItems.insert(contentTypeId)
        }
        
        spotResultsTableView.reloadData()
        //spotResultsTableView.reloadSections(IndexSet(integer: section), with: .automatic)
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
        cell.selectionStyle = .none
        
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
            
            let detailVC = DetailSpotViewController()
            detailVC.selectedSpotItem = selectedItem
            detailVC.getDetailImageList(with: selectedItem)
            detailVC.detailSpotView.getDetail(with: selectedItem)
            detailVC.getSpotCommonInfo(with: selectedItem)
            detailVC.getOverview(with: selectedItem)
            detailVC.getNearbySpotList(with: selectedItem)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            print("Invalid row index")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let button = UIButton(type: .system)
        
        // 현재 섹션의 contentTypeId를 가져오기
        let keys = Array(spotResultsByContentTypeId.keys)
        guard section < keys.count else { return nil }
        let contentTypeId = keys[section]
        
        // showAllItems에 포함 여부에 따라 버튼 제목 설정
        button.setTitle(showAllItems.contains(contentTypeId) ? "접기" : "더 보기", for: .normal)
        button.addTarget(self, action: #selector(didTapShowMoreButton(_:)), for: .touchUpInside)
        button.tag = section
        footerView.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
}
