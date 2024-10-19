//
//  DetailSpotViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class DetailSpotViewController: UIViewController {
    
    // MARK: - Variables
    var selectedSpotItem: AttractionItem?
    
    // MARK: - UI Components
    let detailSpotView: DetailSpotView = {
        let view = DetailSpotView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    

    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureConstraints()
        configureCollectionView()
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(detailSpotView)
        
        let detailSpotViewConstraints = [
            detailSpotView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailSpotView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            detailSpotView.topAnchor.constraint(equalTo: view.topAnchor),
            detailSpotView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(detailSpotViewConstraints)
    }
    
    // MARK: - Functions
    
    /// 컬렉션뷰 관련 설정을 호출하는 메서드
    func configureCollectionView() {
        detailSpotView.detailImageCollectionView.delegate = self
        detailSpotView.detailImageCollectionView.dataSource = self
        detailSpotView.detailImageCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
}


extension DetailSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = .systemRed
        
        return cell
    }
}
