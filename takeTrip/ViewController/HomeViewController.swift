//
//  HomeViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    // 각 섹션별로 타이틀 설정
//    var categories: [String] = ["날이 쌀쌀해질 때 생각나는 온천 여행 ", "아이와 함께 가는 테마 여행", "역사와 문화가 살아 숨쉬는 박물관 여행", "걷고 쉬고 사색하는 도보 코스", "그 옛날 정을 느끼고 싶다면, 시장 여행"]
    var categories: [String] = ["날이 쌀쌀해질 때 생각나는 온천 여행 ", "아이와 함께 가는 테마 여행", "역사와 문화가 살아 숨쉬는 박물관 여행", "그 옛날 정을 느끼고 싶다면, 시장 여행"]
    
    // 데이터를 랜덤으로 가져오기 위해 무작위로 페이지 설정 변수
    let randomPage = String(Int.random(in: 1...15))
    
    
    // MARK: - UI Component
    let homeFeedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none     // 섹션 위, 아래 밑줄 해제
        return tableView
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationItem()
        
        configureConstraints()
        configureHomeFeedTable()
        
        // 화면을 아래로 스크롤하면 네비게이션바 부분이 숨겨지고, 반대로 하면 나타나는 기능
        // self.navigationController?.hidesBarsOnSwipe = false
        
        NetworkManager.shared.searchKeywordList(keyword: "경기") { _ in
            
        }
    }
    
    // MARK: - Function
    /// 네비게이션 아이템 설정 함수
    func configureNavigationItem() {
        
        let titleLabel = UILabel()
        titleLabel.text = "Take a trip"
        titleLabel.textColor = .label
        // titleLabel.font = UIFont(name: "YeongdoOTF-Bold", size: 28)
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        let alarmButton = UIButton(type: .system)
        alarmButton.setImage(UIImage(systemName: "bell"), for: .normal)
        alarmButton.tintColor = .label
        alarmButton.addTarget(self, action: #selector(didTappedAlarmButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: alarmButton)
    }
    
    
    /// 네비게이션 아이템의 알람버튼이 눌리면 호출되는 함수
    @objc func didTappedAlarmButton() {
        print("didTappedAlarmButton called")
    }
    
    
    /// 홈화면의 homeFeedTable 설정 함수
    func configureHomeFeedTable() {
        homeFeedTableView.delegate = self
        homeFeedTableView.dataSource = self
        homeFeedTableView.register(HomeFeedTableViewCell.self, forCellReuseIdentifier: HomeFeedTableViewCell.identifier)
    }
    
    /// 테이블의 섹션에 있는 더보기를 누르면 호출되는 함수
    @objc func moreButtonTapped(_ sender: UIButton) {
        let section = sender.tag
        print("moreButtonTapped called \(section)")
    }
    
    
    
    
    // MARK: - Layouts
    /// UI 요소의 제약조건을 설정하는 함수
    private func configureConstraints() {
        view.addSubview(homeFeedTableView)
        
        let homeFeedTableViewConstraints = [
            homeFeedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeFeedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeFeedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            homeFeedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(homeFeedTableViewConstraints)
    }
}

// MARK: - Extensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource ,HomeFeedTableViewCellDelegate{
    
    func didSelectItem(_ selectedItem: AttractionItem) {
        let detailVC = DetailSpotViewController()
        detailVC.selectedSpotItem = selectedItem
        detailVC.getDetailImageList(with: selectedItem)
        detailVC.detailSpotView.getDetail(with: selectedItem)
        detailVC.getSpotCommonInfo(with: selectedItem)
        detailVC.getOverview(with: selectedItem)
        detailVC.getNearbySpotList(with: selectedItem)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeFeedTableViewCell.identifier, for: indexPath) as? HomeFeedTableViewCell else { return UITableViewCell() }
        
        // HomeFeedTableViewCell 델리게이트 설정
        cell.delegate = self
        
        
        // 열거형으로 컬렉션 뷰의 파라미터 설정
        let spotParameters: SpotPrameters
        
        switch indexPath.section {
        case 0:
            spotParameters = .spaCollection
        case 1:
            spotParameters = .themaCollection
        case 2:
            spotParameters = .museumCollection
        case 3:
            spotParameters = .marketCollection
//        case 3:
//            spotParameters = .tripcourseCollection
//        case 4:
//            spotParameters = .marketCollection
        default:
            spotParameters = .spaCollection
        }
        
        let contentTypeId = spotParameters.contentTypeId
        let cat1 = spotParameters.cat1
        let cat2 = spotParameters.cat2
        let cat3 = spotParameters.cat3
        
        cell.getDataFromAreaBasedList(pageNo: self.randomPage, contentTypeId: contentTypeId, cat1: cat1, cat2: cat2, cat3: cat3)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView,viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "\(categories[section])"
        //label.font = UIFont(name: "HakgyoansimBunpilR", size: 16)
        label.font = .systemFont(ofSize: 18, weight: .black)
        label.textColor = .label
        label.backgroundColor = .clear
        label.textAlignment = .left
        
        headerView.addSubview(label)
        
        let moreButton = UIButton(type: .system)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setTitle("더 보기", for: .normal)
        moreButton.tag = section
        //moreButton.titleLabel?.font = UIFont(name: "HakgyoansimBunpilR", size: 16)
        moreButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        moreButton.setTitleColor(.label, for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonTapped(_:)), for: .touchUpInside)
        
        headerView.addSubview(moreButton)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            moreButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            moreButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
}


// MARK: - Enum 관광지별 파라미터 구분
enum SpotPrameters {
    case spaCollection
    case themaCollection
    case museumCollection
    //case tripcourseCollection
    case marketCollection
    
    var contentTypeId: String {
        switch self {
        case .spaCollection:
            return "12"
        case .themaCollection:
            return "12"
        case .museumCollection:
            return "14"
//        case .tripcourseCollection:
//            return "25"
        case .marketCollection:
            return "38"
        }
    }
    
    var cat1: String {
        switch self {
        case .spaCollection:
            return "A02"
        case .themaCollection:
            return "A02"
        case .museumCollection:
            return "A02"
//        case .tripcourseCollection:
//            return "C01"
        case .marketCollection:
            return "A04"
        }
    }
    
    var cat2: String {
        switch self {
        case .spaCollection:
            return "A0202"
        case .themaCollection:
            return "A0202"
        case .museumCollection:
            return "A0206"
//        case .tripcourseCollection:
//            return "C0115"
        case .marketCollection:
            return "A0401"
        }
    }
    
    var cat3: String {
        switch self {
        case .spaCollection:
            return "A02020300"
        case .themaCollection:
            return "A02020600"
        case .museumCollection:
            return "A02060100"
//        case .tripcourseCollection:
//            return "C01150001"
        case .marketCollection:
            return "A04010200"
        }
    }
}
