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
    var isFetchingData: Bool = false
    var currentPage: Int = 1
    var searchKeyword: String = ""
    var tapGesture: UITapGestureRecognizer?
    
    
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
        
        //tableView.isHidden = true  // 초기에는 테이블뷰를 숨깁니다.
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
        
        
        // 서치바의 리턴 키 타입 설정
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = false // 항상 Enter 키 활성화
        
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
            spotResultsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            spotResultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -5)
            
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
            textField.keyboardType = .default
            textField.leftViewMode = .always  // 텍스트필드의 eftView가 언제 표시될지를 결정하는 속성
        }
    }
    
    /// 네트워크 요청을 통해 키워드 검색 결과를 가져오는 함수
    func searchForKeyword(with keyword: String, pageNo: Int) {
        NetworkManager.shared.searchKeywordList(pageNo: String(pageNo), keyword: keyword) { [weak self] results in
            switch results {
            case .success(let items):
                let searchList = items.response.body.items.item
                if pageNo == 1 {
                    self?.spotResults = searchList
                } else {
                    self?.spotResults.append(contentsOf: searchList)
                }
                DispatchQueue.main.async {
                    self?.spotResultsTableView.reloadData()
                    self?.isFetchingData = false
                }

            case .failure(let error):
                print(error.localizedDescription)
                self?.isFetchingData = false
            }
        }
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate, UITextFieldDelegate {
    
    // 사용자가 서치 버트을 눌렀을 때 호출되는 함수
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let query = searchBar.text, !query.isEmpty else {
//            print("검색어가 비어있습니다.")
//            return
//        }
    
        guard let query = searchBar.text else { return }
        self.searchKeyword = query
        self.searchForKeyword(with: query, pageNo: 1)
        
        searchBar.resignFirstResponder()
    }
    
    
    // 사용자가 검색어를 변경할 때마다 호출되는 함수
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 검색어가 비어있으면 테이블 뷰를 숨김
        if searchText.isEmpty {
            spotResults.removeAll()
            //spotResultsTableView.isHidden = true
            spotResultsTableView.reloadData()
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: spotResultsTableViewCell.identifier, for: indexPath) as? spotResultsTableViewCell else { return UITableViewCell() }
        
        let selectedItem = spotResults[indexPath.row]
        
        cell.configureSearchData(with: selectedItem)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = spotResults[indexPath.item]
        let detailVC = DetailSpotViewController()
        detailVC.selectedSpotItem = selectedItem
        detailVC.getDetailImageList(with: selectedItem)
        detailVC.detailSpotView.getDetail(with: selectedItem)
        detailVC.getSpotCommonInfo(with: selectedItem)
        detailVC.getOverview(with: selectedItem)
        detailVC.getNearbySpotList(with: selectedItem)
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension SearchViewController: UIScrollViewDelegate {
    // 테이블 뷰가 스크롤될때마다 호출됨
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 현재 스크롤 위치의 Y축 오프셋, 사용자가 화면을 아래로 스크롤하면 offsetY값이 증가함
        let offsetY = scrollView.contentOffset.y
        // 스크롤뷰(테이블 뷰)의 전체 콘텐츠 높이, 즉 테이블 내의 셀의 총 높이
        let contentHeight = scrollView.contentSize.height
        // 화면에 보이는 테이블뷰의 높이, 즉 테이블 뷰가 현재 화면에 보여줄 수 있는 높이
        let height = scrollView.frame.size.height

        // 테이블뷰 끝에 도달했을 때 다음 페이지 로드
        if offsetY > contentHeight - height, !isFetchingData {
            isFetchingData = true
            currentPage += 1
            searchForKeyword(with: searchKeyword, pageNo: currentPage)
        }
    }
}
