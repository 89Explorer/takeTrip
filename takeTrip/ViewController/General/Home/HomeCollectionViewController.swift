//
//  HomeCollectionViewController.swift
//  takeTrip
//
//  Created by 권정근 on 11/1/24.
//

import UIKit

class HomeCollectionViewController: UIViewController {
    
     // 데이터를 저장할 배열
     var spotResults: [AttractionItem] = []
     
     // 컬렉션 뷰 생성 및 레이아웃 설정
     lazy var collectionView: UICollectionView = {
         let layout = UICollectionViewFlowLayout()
         layout.itemSize = CGSize(width: view.frame.width, height: 300)
         //layout.minimumInteritemSpacing = 10
         layout.minimumLineSpacing = 10
         
         let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
         collectionView.translatesAutoresizingMaskIntoConstraints = false
         collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
         collectionView.delegate = self
         collectionView.dataSource = self
         return collectionView
     }()
     
     override func viewDidLoad() {
         super.viewDidLoad()
         view.backgroundColor = .systemBackground
         setupLayout()
         configureNavigation()
     }
     
     private func setupLayout() {
         view.addSubview(collectionView)
         
         NSLayoutConstraint.activate([
             collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
             collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
         ])
     }
    
    func configureNavigation() {
        navigationItem.title = "더보기 페이지"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = ""
    }
    
 }

 extension HomeCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return spotResults.count
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCollectionViewCell.identifier, for: indexPath) as? FeedCollectionViewCell else {
             return UICollectionViewCell()
         }
         
         let item = spotResults[indexPath.row]
         cell.configureCollectionViewCell(with: item) // `FeedCollectionViewCell`에 데이터를 설정하는 메서드
         return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         collectionView.deselectItem(at: indexPath, animated: true)   //  셀을 선택 해제하는 역할
         
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
