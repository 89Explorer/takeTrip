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
    var detailImages: [String] = []
    
    // nearbyTable 더보기 관련 현재 보여줄 데이터의 시작 인덱스
    var currentStartIndex: Int = 0
    
    // nearbyTable 더보기 관련 한 번에 보여줄 데이터의 개수
    var pageSize = 3
    
    // nearbyTable 더보기 관련 샘플데이터
    var allData = ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5", "Item 6", "Item 7", "Item 8", "Item 9", "Item 10"]
    
    var nearbySpotList: [AttractionItem] = []
    
    
    
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
        configureNavigation()
        
        didTappedLoadMoreButton()
        
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
        detailSpotView.detailImageCollectionView.register(DetailImageCollectionViewCell.self, forCellWithReuseIdentifier: DetailImageCollectionViewCell.identifier)
    }
    
    /// 테이블뷰 관련 설정을 호출하는 메서드
    func configureTableView() {
        detailSpotView.nearbyTableView.delegate = self
        detailSpotView.nearbyTableView.dataSource = self
        //detailSpotView.nearbyTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        detailSpotView.nearbyTableView.register(NearbySpotTableViewCell.self, forCellReuseIdentifier: NearbySpotTableViewCell.identifier)
    }
    
    func configureNavigation() {
        navigationItem.title = "상세페이지"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    /// detailSpotView 내의  button에 addTarget 호출하는 함수
    func didTappedLoadMoreButton() {
        detailSpotView.button.addTarget(self, action: #selector(loadMoreData), for: .touchUpInside)
    }
    
    /// 버튼 텍스트 업데이트 및 설정
    func configureButton() {
        // 총 페이지 수 계산 (총 아이템이 0인 경우, 최소 1 페이지로 표시)
        let totalPages = max(1, Int(ceil(Double(nearbySpotList.count) / Double(pageSize))))
        let currentPage = (currentStartIndex / pageSize) + 1
        
        // UIButton 설정
        var configuration = UIButton.Configuration.filled()
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        
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
    
    /// 버튼 클릭 시 호출되는 메서드
    @objc func loadMoreData() {
        // 페이지 업데이트
        if currentStartIndex + pageSize < nearbySpotList.count {
            currentStartIndex += pageSize
        } else {
            currentStartIndex = 0
        }
        
        // 테이블뷰 갱신
        detailSpotView.nearbyTableView.reloadData()
        
        // 버튼 텍스트 갱신
        configureButton()
    }
    
    /// 외부 API를 통해 데이터를 받아올 때, 데이터를 받아오는데 오래 걸릴 것을 예상해, 네트워크 요청 실패 시 반복 시도를 추가
    func getDetailImageList(with item: AttractionItem?, retryCount: Int = 3) {
        guard let contentId = item?.contentid else { return }
        
        NetworkManager.shared.getSpotImage(contentId: contentId) { [weak self] results in
            switch results {
            case .success(let items):
                guard let imageItem = items.response.body.items?.item else { return }
                if imageItem.isEmpty {
                    self?.setDefaultImage()
                } else {
                    
                    DispatchQueue.main.async {
                        self?.detailImages = (items.response.body.items?.item?.compactMap({ $0.originimgurl }))!
                        self?.detailSpotView.detailImageCollectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                if retryCount > 0 {
                    self?.getDetailImageList(with: self?.selectedSpotItem, retryCount: retryCount - 1)
                } else {
                    self?.setDefaultImage()
                    DispatchQueue.main.async {
                        self?.detailSpotView.detailImageCollectionView.reloadData()
                    }
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    /// 기본 이미지 URL 또는 로컬 이미지 파일의 이름을 detailMainImage에 배열 형태로 추가
    func setDefaultImage() {
        if let defaultImage = selectedSpotItem?.firstimage {
            detailImages = [defaultImage]    // 기본 이미지의 URL 또는 로컬 이미지의 이름
        } else {
            detailImages = []
        }
    }
    
    /// spot의 기본 정보 + 소개글을 설정하는 함수
    func getSpotCommonInfo(with item: AttractionItem?) {
        
        guard let contentId = item?.contentid,
              let contentTypeId = item?.contenttypeid else { return }
        
        NetworkManager.shared.getDetailIntro(contentId: contentId, contentTypeId: contentTypeId) { [weak self] results in
            switch results {
            case .success(let items):
                guard let infoItems = items.response.body.items?.item else { return }
                let spotPhoneNumber = infoItems[0].phoneNumber
                let spotOperateTime = infoItems[0].operatingTime
                let spotAddress = self?.detailSpotView.spotAddress
                let spotHomePage = self?.detailSpotView.spotHomePage
                
                var spotOverView = self?.detailSpotView.spotOverview
                
                if spotOverView?.count == 0 {
                    spotOverView = "소개글이 없어요 😀"
                } else {
                    spotOverView = self?.detailSpotView.spotOverview
                }
                
                let modifiedOperateTime = self?.removeHTMLTags(from: spotOperateTime!)
                
                DispatchQueue.main.async {
                    self?.detailSpotView.configureSpotInfo(spotAddress: spotAddress, spotPhone: spotPhoneNumber, spotWebsite: spotHomePage, spotOperateTime: modifiedOperateTime)
                    self?.detailSpotView.spotOverviewValue.text = spotOverView
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// spot의 소개글을 가져오는 함수
    func getOverview(with item: AttractionItem?) {
        
        guard let contentId = item?.contentid,
              let contenttypeid = item?.contenttypeid else { return }
        
        NetworkManager.shared.getCommonData(contentId: contentId, contentTypeId: contenttypeid) { [weak self] results in
            switch results {
            case .success(let item):
                
                guard let spotOverview = item.response.body.items.item[0].overview,
                      let spotHomePage = item.response.body.items.item[0].homepage else { return }
                
                let spotURL = self?.extractURL(from: spotHomePage)
                
                self?.detailSpotView.spotOverview = spotOverview
                self?.detailSpotView.spotHomePage = spotURL ?? ""
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// spot 근처 관련 명소 리스트 불러오는 함수
    func getNearbySpotList(with item: AttractionItem?) {
        guard let spotMapX = item?.mapx,
              let spotMapY = item?.mapy else { return }
        
        NetworkManager.shared.getLocationBasedList(mapX: spotMapX, mapY: spotMapY) {  results in
            switch results {
            case .success(let item):
                self.nearbySpotList = item.response.body.items.item
                
                DispatchQueue.main.async {
                    self.detailSpotView.nearbyTableView.reloadData()
                    self.configureButton()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    /// <br> 태그를 제거하는 함수
    func removeHTMLTags(from text: String) -> String {
        // <br> 태그를 줄바꿈으로 바꾸고, 다른 HTML 태그는 모두 제거합니다.
        var cleanedText = text.replacingOccurrences(of: "<br>", with: " ")
        cleanedText = cleanedText.replacingOccurrences(of: "<br/>", with: "")
        
        // 추가로, 다른 HTML 태그들도 제거하고 싶다면, 아래 정규식을 사용하여 모든 태그를 제거할 수 있습니다.
        if let regex = try? NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive) {
            cleanedText = regex.stringByReplacingMatches(in: cleanedText, options: [], range: NSRange(location: 0, length: cleanedText.count), withTemplate: "")
        }
        
        return cleanedText
    }
    
    /// HTML 태그를 제거하고 실제 URL 주소만 추출하는 함수
    func extractURL(from htmlString: String) -> String? {
        // 정규식을 사용하여 HTML 태그 내 URL을 추출
        let pattern = #"href="([^"]+)""#
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            if let match = regex.firstMatch(in: htmlString, options: [], range: NSRange(htmlString.startIndex..., in: htmlString)) {
                if let range = Range(match.range(at: 1), in: htmlString) {
                    return String(htmlString[range])
                }
            }
        } catch {
            print("Regex error: \(error)")
        }
        return nil
    }
    
    
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension DetailSpotViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCollectionViewCell.identifier, for: indexPath) as? DetailImageCollectionViewCell else { return UICollectionViewCell() }
        
        let imageURL = detailImages[indexPath.item]
        cell.getDetailImage(with: imageURL)
        
        return cell
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource
extension DetailSpotViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let remainingDataCount = nearbySpotList.count - currentStartIndex
        
        return min(pageSize, remainingDataCount)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NearbySpotTableViewCell.identifier, for: indexPath) as? NearbySpotTableViewCell else { return UITableViewCell() }
        
        let index = currentStartIndex + indexPath.row
        let selectedItem = nearbySpotList[index]
        cell.configureTableView(with: selectedItem)
        
        cell.selectionStyle = .none
        
        return cell
        
        // let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        // let index = currentStartIndex + indexPath.row
        // cell.textLabel?.text = allData[index]
        
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
