//
//  UserFeedViewController.swift
//  takeTrip
//
//  Created by 권정근 on 11/11/24.
//

import UIKit

class UserFeedViewController: UIViewController {
    
    // MARK: - Variables
    var userFeed: FeedItem?
    
    // MARK: - UI Components
    let feedScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    let feedImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        //collectionView.layer.cornerRadius = 10
        //collectionView.clipsToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let feedLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "장소: 고양 어린이 박물관"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let feedCategoryLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "드라이브 🚗"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.backgroundColor = .label
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    let feedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2002-22-22"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let feedContentLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 정말 멋진 날이다."
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureConstarints()
        configureCollectionView()
        configureData()
        setupNavigationBar()
    }
    
    
    // MARK: - Layouts
    private func configureConstarints() {
        view.addSubview(feedScrollView)
        
        feedScrollView.addSubview(feedImageCollectionView)
        feedScrollView.addSubview(feedLocationLabel)
        feedScrollView.addSubview(feedCategoryLabel)
        feedScrollView.addSubview(feedContentLabel)
        feedScrollView.addSubview(feedDateLabel)
        

        feedScrollView.translatesAutoresizingMaskIntoConstraints = false
        feedImageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        feedLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        feedCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        feedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        feedContentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            feedScrollView.leadingAnchor.constraint(equalTo: view
                .leadingAnchor),
            feedScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            feedScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            feedScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            feedImageCollectionView.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor),
            feedImageCollectionView.trailingAnchor.constraint(equalTo: feedScrollView.trailingAnchor),
            feedImageCollectionView.widthAnchor.constraint(equalTo: feedScrollView.widthAnchor),
            feedImageCollectionView.topAnchor.constraint(equalTo: feedScrollView.safeAreaLayoutGuide.topAnchor),
            feedImageCollectionView.heightAnchor.constraint(equalToConstant: 300),
            
            feedLocationLabel.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 10),
            feedLocationLabel.topAnchor.constraint(equalTo: feedImageCollectionView.bottomAnchor, constant: 10),
            feedLocationLabel.trailingAnchor.constraint(equalTo: feedScrollView.trailingAnchor, constant: -10),
            
            feedCategoryLabel.topAnchor.constraint(equalTo: feedLocationLabel.bottomAnchor, constant: 5),
            feedCategoryLabel.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 10),
            
            feedDateLabel.trailingAnchor.constraint(equalTo: feedScrollView.trailingAnchor, constant: -10),
            feedDateLabel.topAnchor.constraint(equalTo: feedLocationLabel.bottomAnchor, constant: 5),
            
            
            feedContentLabel.leadingAnchor.constraint(equalTo: feedScrollView.leadingAnchor, constant: 10),
            feedContentLabel.trailingAnchor.constraint(equalTo: feedScrollView.trailingAnchor, constant: -10),
            feedContentLabel.topAnchor.constraint(equalTo: feedCategoryLabel.bottomAnchor, constant: 15),
            feedContentLabel.bottomAnchor.constraint(equalTo: feedScrollView.bottomAnchor, constant: -5)
            
        ])
    }
    
    
    // MARK: - Functions
    func configureCollectionView() {
        feedImageCollectionView.delegate = self
        feedImageCollectionView.dataSource = self
        feedImageCollectionView.register(DetailImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailImageCollectionViewCell.identifier)
    }
    
    func configureData() {
        guard let userFeed = userFeed else { return }
        
        guard let feedDate = userFeed.date else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: feedDate)
        
        feedDateLabel.text = dateString
        feedContentLabel.text = userFeed.tripLog
        feedCategoryLabel.text = userFeed.category
        feedLocationLabel.text = userFeed.location
    }
    
    func setupNavigationBar() {
        let setupButton = UIButton(type: .system)
        setupButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        setupButton.tintColor = .label
        setupButton.addTarget(self, action: #selector(didTappedSetupButton), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: setupButton)
    }
    
    @objc func didTappedSetupButton() {
        print("didTappedSetupButton() - called")
        
        let profileFeedEditVC = ProfileFeedEditViewController()
        
        if let sheet = profileFeedEditVC.sheetPresentationController {
            // sheet.detents = [.medium()]
            
            // sheet 올라오는 높이 조절
            sheet.detents = [
                .custom { context in
                    return 200
                }
            ]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        profileFeedEditVC.modalPresentationStyle = .pageSheet
        present(profileFeedEditVC, animated: true)
    }
    
}


extension UserFeedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userFeed?.images?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionViewCell.identifier, for: indexPath) as? DetailImageCollectionViewCell else { return UICollectionViewCell() }
        
        if let images = userFeed?.images {
            cell.getUserImage(with: images[indexPath.item])
        }
        
        return cell
    }
}
