//
//  ProfileViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Variables
    var categories: [String] = ["작성한 피드", "담아둔 장소"]
    var selectedIndex: Int = 0    // 현재 선택된 셀의 인덱스
    var feedItems: [FeedItem] = []
    
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        return view
    }()
    
    let profileHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "korea")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    var profileName: UILabel = {
        let label = UILabel()
        label.text = "동동이"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .black)
        return label
    }()
    
    var profileDescription: UILabel = {
        let label = UILabel()
        label.text = "I'm a traveller who loves to explore new places."
        label.textColor = .label
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    var profileEditButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseForegroundColor = .label
        configuration.baseBackgroundColor = .secondarySystemBackground
        configuration.cornerStyle = .large
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        configuration.title = "프로필 수정"
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        configuration.image = UIImage(systemName: "person.crop.circle")
        configuration.imagePlacement = .leading
        configuration.imagePadding = 5
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        configuration.imagePadding = 10
        
        let button = UIButton(configuration: configuration)
        return button
    }()
    
    let profileBodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray.cgColor
        view.clipsToBounds = true
        return view
    }()
    
    let profileCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        //layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // 셀 크기를 자동으로 조정
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let profileFeedTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        configureConstraints()
        
        configureTableView()
        configureCollectionView()
        
        // feedItems 로드
        feedItems = FeedDataManager.shared.fetchFeedItems()
        
        print(feedItems)
        
        
        // 삭제 완료 알림 등록
        NotificationCenter.default.addObserver(self, selector: #selector(handleDeleteNotification), name: NSNotification.Name("DeleteItemNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        feedItems = FeedDataManager.shared.fetchFeedItems()
        profileFeedTableView.reloadData()
        print(feedItems)
    }
    
    
    // MARK: - Initializations
    private func configureConstraints() {
        view.addSubview(basicView)
        
        basicView.addSubview(profileHeaderView)
        
        profileHeaderView.addSubview(profileImage)
        profileHeaderView.addSubview(profileStackView)
        profileHeaderView.addSubview(profileEditButton)
        profileStackView.addArrangedSubview(profileName)
        profileStackView.addArrangedSubview(profileDescription)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileStackView.translatesAutoresizingMaskIntoConstraints = false
        profileName.translatesAutoresizingMaskIntoConstraints = false
        profileDescription.translatesAutoresizingMaskIntoConstraints = false
        profileEditButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        basicView.addSubview(profileBodyView)
        
        profileBodyView.addSubview(profileCollectionView)
        profileBodyView.addSubview(profileFeedTableView)
        
        profileBodyView.translatesAutoresizingMaskIntoConstraints = false
        profileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        profileFeedTableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: view.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            profileHeaderView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            profileHeaderView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            profileHeaderView.topAnchor.constraint(equalTo: basicView.safeAreaLayoutGuide.topAnchor, constant: 5),
            profileHeaderView.heightAnchor.constraint(equalToConstant: 150),
            
            profileImage.leadingAnchor.constraint(equalTo: profileHeaderView.leadingAnchor, constant: 5),
            profileImage.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor),
            profileImage.heightAnchor.constraint(equalToConstant: 140),
            profileImage.widthAnchor.constraint(equalToConstant: 140),
            
            profileStackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 15),
            profileStackView.trailingAnchor.constraint(equalTo: profileHeaderView.trailingAnchor, constant: -10),
            profileStackView.centerYAnchor.constraint(equalTo: profileHeaderView.centerYAnchor, constant: -10),
            
            profileEditButton.leadingAnchor.constraint(equalTo: profileStackView.leadingAnchor),
            profileEditButton.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 10),
            
            profileBodyView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            profileBodyView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            profileBodyView.topAnchor.constraint(equalTo: profileHeaderView.bottomAnchor, constant: 5),
            profileBodyView.bottomAnchor.constraint(equalTo: basicView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            
            profileCollectionView.leadingAnchor.constraint(equalTo: profileBodyView.leadingAnchor),
            profileCollectionView.trailingAnchor.constraint(equalTo: profileBodyView.trailingAnchor),
            profileCollectionView.topAnchor.constraint(equalTo: profileBodyView.topAnchor),
            profileCollectionView.heightAnchor.constraint(equalToConstant: 40),
            
            profileFeedTableView.leadingAnchor.constraint(equalTo: profileBodyView.leadingAnchor, constant: 5),
            profileFeedTableView.trailingAnchor.constraint(equalTo: profileBodyView.trailingAnchor, constant: -5),
            profileFeedTableView.topAnchor.constraint(equalTo: profileCollectionView.bottomAnchor),
            profileFeedTableView.bottomAnchor.constraint(equalTo: profileBodyView.bottomAnchor, constant: -10)
            
        ])
        
    }
    
    
    // MARK: - Functions
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }
    
    func configureCollectionView() {
        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
        profileCollectionView.register(ProfileCollectionCell.self, forCellWithReuseIdentifier: ProfileCollectionCell.identifier )
    }
    
    func configureTableView() {
        profileFeedTableView.delegate = self
        profileFeedTableView.dataSource = self
        profileFeedTableView.register(FeedTableCell.self, forCellReuseIdentifier: FeedTableCell.identifier)
    }
    
    
    @objc private func handleDeleteNotification() {
        // 삭제된 후 pop 동작 수행
        self.navigationController?.popViewController(animated: true)
    }

    deinit {
        // 메모리 누수를 방지하기 위해 Notification 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("DeleteItemNotification"), object: nil)
    }
}



extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionCell.identifier, for: indexPath) as? ProfileCollectionCell else { return UICollectionViewCell() }
        
        let seletedItem = categories[indexPath.row]
        cell.updateTitleLabel(with: seletedItem)
        
        // 선택된 셀인지 확인하여 스타일 적용
        if indexPath.row == selectedIndex {
            cell.titleLabel.textColor = .systemRed
            cell.underLine.isHidden = false
        } else {
            cell.titleLabel.textColor = .label
            cell.underLine.isHidden = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // 현재 선택된 인덱스를 업데이트
        selectedIndex = indexPath.item
        collectionView.reloadData()
        
    }
}


extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableCell.identifier, for: indexPath) as? FeedTableCell else { return UITableViewCell() }
        
        let feedItem = feedItems[indexPath.row]
        cell.configure(with: feedItem) // FeedTableCell에 FeedItem 전달
        
        return cell
    }
    
    // 스와이프하여 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Core Data에서 삭제
            let feedItemToDelete = feedItems[indexPath.row]
            let feedID = feedItemToDelete.feedID
            print("삭제할 FeedItem의 ID: \(feedID)") // 삭제할 feedID 출력
            FeedDataManager.shared.deleteFeedItem(feedID: feedID)
            
            // 배열 및 테이블뷰에서 삭제
            feedItems.remove(at: indexPath.row)
            print(feedItems)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userFeedVC = UserFeedViewController()
        let selectedItem = feedItems[indexPath.item]
        userFeedVC.userFeed = selectedItem
        navigationController?.pushViewController(userFeedVC, animated: true)
    }
}
