//
//  HomeViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Variables
    var categories: [String] = ["날이 쌀쌀해질 때 생각나는 온천여행 ", "문화 여행", "음식 여행", "코스 여행", "쇼핑 여행"]
    
    
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
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    
    // MARK: - Function
    /// 네비게이션 아이템 설정 함수
    func configureNavigationItem() {
        
//        let titleLabel = UILabel()
//        titleLabel.text = "Take a trip"
//        titleLabel.textColor = .label
//        titleLabel.font = UIFont(name: "YeongdoOTF-Bold", size: 28)
//        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)

        let originalImage = UIImage(named: "taketriplogo-removebg.png")
        let scaledSize = CGSize(width: 40, height: 40) // 시스템 버튼과 비슷한 크기

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        originalImage?.draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // 원본 이미지 색상을 유지하기 위해 렌더링 모드를 .alwaysOriginal로 설정
        let originalColorImage = scaledImage?.withRenderingMode(.alwaysOriginal)

        let barButton = UIBarButtonItem(image: originalColorImage, style: .plain, target: self, action: #selector(leftBarButtonTapped))
        navigationItem.leftBarButtonItem = barButton
        
        
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
    
    
    @objc private func leftBarButtonTapped() {
        print("Logo image Called")
    }
    
    // MARK: - Layouts
    /// UI 요소의 제약조건을 설정하는 함수
    private func configureConstraints() {
        view.addSubview(homeFeedTableView)
        
        let homeFeedTableViewConstraints = [
            homeFeedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeFeedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeFeedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            homeFeedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(homeFeedTableViewConstraints)
    }
}

// MARK: - Extensions
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeFeedTableViewCell.identifier, for: indexPath) as? HomeFeedTableViewCell else { return UITableViewCell() }
        
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
        label.font = .systemFont(ofSize: 16, weight: .black)
        label.textColor = .label
        label.backgroundColor = .clear
        label.textAlignment = .left
        
        headerView.addSubview(label)
        
        let moreButton = UIButton(type: .system)
        moreButton.translatesAutoresizingMaskIntoConstraints = false
        moreButton.setTitle("더 보기", for: .normal)
        moreButton.tag = section
        //moreButton.titleLabel?.font = UIFont(name: "HakgyoansimBunpilR", size: 16)
        moreButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .light)
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
