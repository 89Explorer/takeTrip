//
//  HomeFeedTableViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {
    
    
    // MARK: - Variables
    static let identifier = "HomeFeedTableViewCell"
    
    
    // MARK: - UI Components
    let feedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 320)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        configureConstraints()
        configureFeedCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    /// feedCollectionView 관련 설정 함수
    func configureFeedCollectionView() {
        feedCollectionView.delegate = self
        feedCollectionView.dataSource = self
        feedCollectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(feedCollectionView)
        
        let feedCollectionViewConstraints = [
            feedCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            feedCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            feedCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            feedCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(feedCollectionViewConstraints)
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDatasource
extension HomeFeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)   //  셀을 선택 해제하는 역할
        print("collectionView selected index: \(indexPath.item)")
    }
}
