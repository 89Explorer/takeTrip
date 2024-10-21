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
    
    // nearbyTable 더보기 관련 현재 보여줄 데이터의 시작 인덱스
    var currentStartIndex: Int = 0
    
    // nearbyTable 더보기 관련 한 번에 보여줄 데이터의 개수
    var pageSize = 3
    
    // nearbyTable 더보기 관련 샘플데이터
    var allData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    
    
    
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
        configureTableView()
        configureButton()
        
        didTappedLoadMoreButton()
        print(selectedSpotItem?.contentid)
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
    
    /// 테이블뷰 관련 설정을 호출하는 메서드
    func configureTableView() {
        detailSpotView.nearbyTableView.delegate = self
        detailSpotView.nearbyTableView.dataSource = self
        detailSpotView.nearbyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //detailSpotView.nearbyTableView.register(NearbySpotTableViewCell.self, forCellReuseIdentifier: NearbySpotTableViewCell.identifier)
    }
    
    func didTappedLoadMoreButton() {
        detailSpotView.button.addTarget(self, action: #selector(loadMoreData), for: .touchUpInside)
    }
    
    // 버튼 텍스트 업데이트 및 설정
    func configureButton() {
        // 페이지 수 계산
        let totalPages = Int(ceil(Double(allData.count) / Double(pageSize)))
        let currentPage = (currentStartIndex / pageSize) + 1
        
        // UIButton 설정
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        configuration.baseForegroundColor = .label
        configuration.baseBackgroundColor = .secondarySystemBackground
        configuration.attributedTitle = AttributedString(
            "주변 추천 장소 더보기 (\(currentPage)/\(totalPages))",
            attributes: titleContainer
        )
        configuration.titleAlignment = .center
        configuration.image = UIImage(systemName: "arrow.clockwise")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        configuration.imagePadding = 10
        configuration.titleAlignment = .leading

        // 버튼 설정 적용
        detailSpotView.button.configuration = configuration
    }
    
    // 버튼 클릭 시 호출되는 메서드
    @objc func loadMoreData() {
        // 페이지 업데이트
        if currentStartIndex + pageSize < allData.count {
            currentStartIndex += pageSize
        } else {
            currentStartIndex = 0
        }
        
        // 테이블뷰 갱신
        detailSpotView.nearbyTableView.reloadData()

        // 버튼 텍스트 갱신
        configureButton()
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
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


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailSpotViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let remainingDataCount = allData.count - currentStartIndex
        
        return min(pageSize, remainingDataCount)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbySpotTableViewCell.identifier, for: indexPath) as? NearbySpotTableViewCell else { return UITableViewCell() }
        //
        //        cell.selectionStyle = .none
        //
        //        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let index = currentStartIndex + indexPath.row
        cell.textLabel?.text = allData[index]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //
    //        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
    //        let button = UIButton(type: .system)
    //        button.frame = footerView.bounds
    //        button.setTitle("더 보기", for: .normal)
    //        //button.addTarget(self, action: #selector(loadMoreData), for: .touchUpInside)
    //        footerView.addSubview(button)
    //        return footerView
    //        let footerView = UIView()
    //
    //        footerView.backgroundColor = .clear
    //
    //        var configuration = UIButton.Configuration.filled()
    //        configuration.baseBackgroundColor = .secondarySystemBackground
    //        configuration.baseForegroundColor = .label
    //        configuration.cornerStyle = .medium
    //
    //        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
    //
    //        configuration.title = "주변 추천 장소 더보기 1/3"
    //        configuration.titleAlignment = .center
    //        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    //
    //        let button = UIButton(configuration: configuration)
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //
    //        footerView.addSubview(button)
    //
    //        NSLayoutConstraint.activate([
    //            button.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
    //            button.centerYAnchor.constraint(equalTo: footerView.centerYAnchor,constant: 0),
    //            button.widthAnchor.constraint(equalToConstant: 240),
    //            button.heightAnchor.constraint(equalToConstant: 45)
    //        ])
    //
    //        return footerView
    //    }
}
