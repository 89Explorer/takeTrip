//
//  DetailSpotView.swift
//  takeTrip
//
//  Created by 권정근 on 10/19/24.
//

import UIKit

class DetailSpotView: UIView {
    
    // MARK: - Variables
    private var isExpanded: Bool = false // 더보기 상태 트래킹
    var selectedSpotInfo: [InfoItem] = []
    
    var spotAddress: String = ""
    var spotPhoneNumber: String = ""
    var spotOperateTime: String = ""
    var spotHomePage: String = ""
    var spotOverview: String = ""
    
    // MARK: - UI Components
    let basicView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never // Safe Area 인셋 무시
        return view
    }()
    
    /// 디테일 화면에서 헤더에 해당하는 뷰
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner,
                                    .layerMaxXMaxYCorner]  // 좌, 우 하단 적용
        return view
    }()
    
    lazy var spotTitleCategoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    var spotTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "평택 메타세콰이어"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    var spotCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "공원"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "square.and.arrow.up.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let bagButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "bookmark.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let detailImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let spotInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        return view
    }()
    
    lazy var totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    let spotOverviewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        return view
    }()
    
    lazy var spotOverviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var spotOverviewLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    let spotOverviewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "book.circle", withConfiguration: configure)
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }()
    
    let spotOverviewTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "소개"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let spotOverviewValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "소개글이 없어요 😅"
        label.numberOfLines = 1
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let moreOverviewButton: UIButton = {
        var configuration = UIButton.Configuration.plain() // 버튼 스타일 설정
        configuration.title = "더 보기"
        configuration.baseForegroundColor = .label // 텍스트 색상 설정
        
        // 텍스트 스타일 설정
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 12, weight: .bold) // 글자 크기 12
            return outgoing
        }
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nearbySpotView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        return view
    }()
    
    let nearbySpotTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    let nearbySpotImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "flag.circle", withConfiguration: configure)
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }()
    
    let nearbySpotTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "주변에 가볼만 한 장소"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let nearbyTableView: IntrinsicTableView = {
        let tableView = IntrinsicTableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemRed
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var button: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .secondarySystemBackground
        configuration.baseForegroundColor = .label
        configuration.cornerStyle = .medium
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        var titleContainer = AttributeContainer()
        titleContainer.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        // configuration.attributedTitle = AttributedString("주변 추천 장소 더보기 (1/3)", attributes: titleContainer)
        //configuration.title = "주변 추천 장소 더보기 1/3"
        configuration.titleAlignment = .center
        //configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        configuration.image = UIImage(systemName: "arrow.clockwise")
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 15)
        configuration.imagePadding = 10
        configuration.titleAlignment = .leading
        
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .secondarySystemBackground
        configureConstraints()
        
        
        // 스팟 정보를 설정하는 곳에서 호출
        configureSpotInfo(spotAddress: "경기도 고양시 덕양구 화정동 111-2번지 화정역", spotPhone: "123-1234-1234", spotWebsite: nil, spotOperateTime: "오전 09:00 ~ 오후 18:00")
      

        moreOverviewButton.addTarget(self, action: #selector(toggleTextExpansion), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(headerView)
        headerView.addSubview(spotTitleCategoryStackView)
        spotTitleCategoryStackView.addArrangedSubview(spotTitle)
        spotTitleCategoryStackView.addArrangedSubview(spotCategory)
        headerView.addSubview(sharedButton)
        headerView.addSubview(bagButton)
        headerView.addSubview(detailImageCollectionView)
        
        basicView.addSubview(spotInfoView)
        spotInfoView.addSubview(totalStackView)
        
        basicView.addSubview(spotOverviewView)
        spotOverviewView.addSubview(spotOverviewStackView)
        spotOverviewView.addSubview(moreOverviewButton)
        spotOverviewStackView.addArrangedSubview(spotOverviewImage)
        spotOverviewStackView.addArrangedSubview(spotOverviewLabelStackView)
        spotOverviewLabelStackView.addArrangedSubview(spotOverviewTitle)
        spotOverviewLabelStackView.addArrangedSubview(spotOverviewValue)
        
        basicView.addSubview(nearbySpotView)
        nearbySpotView.addSubview(nearbySpotTitleStackView)
        nearbySpotView.addSubview(button)
        //nearbySpotView.addSubview(nearbySpotStackView)
        nearbySpotView.addSubview(nearbyTableView)
        nearbySpotTitleStackView.addArrangedSubview(nearbySpotImage)
        nearbySpotTitleStackView.addArrangedSubview(nearbySpotTitle)
        
        
        
        let basicViewConstraints = [
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100)
        ]
        
        let headerViewConstraints = [
            headerView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: basicView.topAnchor),
            headerView.widthAnchor.constraint(equalTo: basicView.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 470),
        ]
        
        let spotTitleCategoryStackViewConstraints = [
            spotTitleCategoryStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            spotTitleCategoryStackView.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            spotTitleCategoryStackView.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let sharedButtonConstraints = [
            sharedButton.centerYAnchor.constraint(equalTo: spotTitleCategoryStackView.centerYAnchor),
            sharedButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15)
        ]
        
        let bagButtonConstraints = [
            bagButton.centerYAnchor.constraint(equalTo: spotTitleCategoryStackView.centerYAnchor),
            bagButton.trailingAnchor.constraint(equalTo: sharedButton.leadingAnchor, constant: -15)
        ]
        
        let detailImageCollectionViewConstraints = [
            detailImageCollectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            detailImageCollectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            detailImageCollectionView.topAnchor.constraint(equalTo: spotTitleCategoryStackView.bottomAnchor, constant: 15),
            detailImageCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let spotInfoViewConstraints = [
            spotInfoView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            spotInfoView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            spotInfoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            spotInfoView.widthAnchor.constraint(equalTo: basicView.widthAnchor),
            spotInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ]
        
        let totalStackViewConstraints = [
            totalStackView.leadingAnchor.constraint(equalTo: spotInfoView.leadingAnchor, constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: spotInfoView.trailingAnchor, constant: -10),
            totalStackView.topAnchor.constraint(equalTo: spotInfoView.topAnchor, constant: 5),
            totalStackView.bottomAnchor.constraint(equalTo: spotInfoView.bottomAnchor, constant: -5)
        ]
        
        let spotOverviewViewConstraints = [
            spotOverviewView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            spotOverviewView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            spotOverviewView.topAnchor.constraint(equalTo: spotInfoView.bottomAnchor, constant: 10),
            spotOverviewView.widthAnchor.constraint(equalTo: basicView.widthAnchor),
            spotOverviewView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ]
        
        let spotOverviewStackViewConstraints = [
            spotOverviewStackView.leadingAnchor.constraint(equalTo: spotOverviewView.leadingAnchor, constant: 10),
            spotOverviewStackView.trailingAnchor.constraint(equalTo: spotOverviewView.trailingAnchor, constant: -10),
            spotOverviewStackView.topAnchor.constraint(equalTo: spotOverviewView.topAnchor, constant: 5),
            spotOverviewStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80),
            spotOverviewStackView.bottomAnchor.constraint(equalTo: spotOverviewView.bottomAnchor, constant: -20)
        ]
        
        let spotOverviewImageConstraints = [
            spotOverviewImage.widthAnchor.constraint(equalToConstant: 25),
            spotOverviewImage.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        let moreOverviewButtonConstraints = [
            moreOverviewButton.trailingAnchor.constraint(equalTo: spotOverviewView.trailingAnchor, constant: -10),
            moreOverviewButton.bottomAnchor.constraint(equalTo: spotOverviewView.bottomAnchor)
        ]
        
        let nearbySpotViewConstraints = [
            nearbySpotView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            nearbySpotView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            nearbySpotView.topAnchor.constraint(equalTo: spotOverviewView.bottomAnchor, constant: 10),
            nearbySpotView.heightAnchor.constraint(greaterThanOrEqualToConstant: 250),
            nearbySpotView.widthAnchor.constraint(equalTo: basicView.widthAnchor),
            nearbySpotView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -5)
        ]
        
        let nearbySpotTitleStackViewConstraints = [
            nearbySpotTitleStackView.leadingAnchor.constraint(equalTo: nearbySpotView.leadingAnchor, constant: 10),
            nearbySpotTitleStackView.trailingAnchor.constraint(equalTo: nearbySpotView.trailingAnchor, constant: -10),
            nearbySpotTitleStackView.topAnchor.constraint(equalTo: nearbySpotView.topAnchor, constant: 5),
            nearbySpotTitleStackView.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let nearbySpotImageConstraints = [
            nearbySpotImage.widthAnchor.constraint(equalToConstant: 25),
            nearbySpotImage.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        let nearbyTableViewConstraints = [
            nearbyTableView.leadingAnchor.constraint(equalTo: nearbySpotView.leadingAnchor, constant: 10),
            nearbyTableView.trailingAnchor.constraint(equalTo: nearbySpotView.trailingAnchor, constant: -10),
            nearbyTableView.topAnchor.constraint(equalTo: nearbySpotTitleStackView.bottomAnchor),
            // nearbyTableView.bottomAnchor.constraint(equalTo: nearbySpotView.bottomAnchor, constant: -10)
        ]
        
        let buttonConstraints = [
            button.leadingAnchor.constraint(equalTo: nearbySpotView.leadingAnchor,constant: 10),
            button.trailingAnchor.constraint(equalTo: nearbySpotView.trailingAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: nearbyTableView.bottomAnchor, constant: 10),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: nearbySpotView.bottomAnchor, constant: -10)
        ]
    
        
        NSLayoutConstraint.activate(basicViewConstraints)
        NSLayoutConstraint.activate(headerViewConstraints)
        NSLayoutConstraint.activate(spotTitleCategoryStackViewConstraints)
        NSLayoutConstraint.activate(sharedButtonConstraints)
        NSLayoutConstraint.activate(bagButtonConstraints)
        NSLayoutConstraint.activate(detailImageCollectionViewConstraints)
        NSLayoutConstraint.activate(spotInfoViewConstraints)
        NSLayoutConstraint.activate(totalStackViewConstraints)
        
        NSLayoutConstraint.activate(spotOverviewViewConstraints)
        NSLayoutConstraint.activate(spotOverviewStackViewConstraints)
        NSLayoutConstraint.activate(spotOverviewImageConstraints)
        NSLayoutConstraint.activate(moreOverviewButtonConstraints)
        
        NSLayoutConstraint.activate(nearbySpotViewConstraints)
        NSLayoutConstraint.activate(nearbySpotTitleStackViewConstraints)
        //NSLayoutConstraint.activate(nearbySpotStackViewConstraints)
        NSLayoutConstraint.activate(nearbySpotImageConstraints)
        NSLayoutConstraint.activate(nearbyTableViewConstraints)
        NSLayoutConstraint.activate(buttonConstraints)
        
    }
    
    
    // MARK: - Functions
    /// 외부에서 받아온 데이터 중에서 파라미터에 해당하는 값을 가져와 각 stackview를 구현하는 함수를 호출하는 함수
    func configureSpotInfo(spotAddress: String?, spotPhone: String?, spotWebsite: String?, spotOperateTime: String?) {
        // 먼저 기존 스택의 모든 서브뷰 제거
        totalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Address Section
        if let address = spotAddress {
            let addressStack = createHorizontalStackView(
                image: UIImage(systemName: "location.circle"),
                title: "주소",
                value: address
                //button: moveToPageButton
            )
            totalStackView.addArrangedSubview(addressStack)
        }
        
        // Phone Section
        if let phone = spotPhone {
            let phoneStack = createHorizontalStackView(
                image: UIImage(systemName: "phone.circle"),
                title: "전화",
                value: phone
                //button: moveToPageButton
            )
            totalStackView.addArrangedSubview(phoneStack)
        }
        
        // Website Section
        if let website = spotWebsite {
            let websiteStack = createHorizontalStackView(
                image: UIImage(systemName: "globe"),
                title: "홈페이지",
                value: website
                //button: moveToPageButton
            )
            totalStackView.addArrangedSubview(websiteStack)
        }
        
        // Operate Section'
        if let operateTime = spotOperateTime {
            let operateStack = createHorizontalStackView(
                image: UIImage(systemName: "clock.circle"),
                title: "영업시간",
                value: operateTime
                //button: moveToPageButton
            )
            totalStackView.addArrangedSubview(operateStack)
        }
        
    }
    
    /// image, title, value 파라미터의 값을 받아서 가로 방향으로 스택뷰를 만들어주는 함수 (여행지의 기본정보를 받음)
    func createHorizontalStackView(image: UIImage?, title: String, value: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        
        let imageView = UIImageView(image: image)
        imageView.tintColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.numberOfLines = 0
        
        let textStack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        
        let moveToPageButton = UIButton(type: .system)
        moveToPageButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        moveToPageButton.tintColor = .label
        moveToPageButton.translatesAutoresizingMaskIntoConstraints = false
        moveToPageButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        moveToPageButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textStack)
        stackView.addArrangedSubview(moveToPageButton)
        
        return stackView
    }

    
    /// Overview의 소개 글을 처음에는 5줄, 누르면 텍스트 길이에 맞게 늘려주는 함수
    @objc private func toggleTextExpansion() {
        isExpanded.toggle() // 상태 변경
        
        if isExpanded {
            spotOverviewValue.numberOfLines = 0 // 전체 텍스트 표시
            moreOverviewButton.setTitle("줄이기", for: .normal)
        } else {
            spotOverviewValue.numberOfLines = 1 // 1줄로 다시 제한
            moreOverviewButton.setTitle("더보기", for: .normal)
        }
        
        // 레이아웃 업데이트 (애니메이션 포함)
        UIView.animate(withDuration: 0.3) {
            self.spotOverviewView.layoutIfNeeded() // 높이 자동 조정
        }
    }
    
    /// 디테일 화면에 필요한 내용을 입력하는 함수
    func getDetail(with selectedItem: AttractionItem) {
        let spotName = selectedItem.title
        let spotCategory = selectedItem.cat3
        
        if let categoryEnum = ThirdCategory(rawValue: spotCategory) {
            self.spotCategory.text = categoryEnum.displayName
        } else {
            self.spotCategory.text = ""
        }
    
        self.spotTitle.text = spotName
        self.spotAddress = selectedItem.addr1
        self.spotHomePage = selectedItem.homepage ?? "-"
    }
    
    
    /// 외부에서 받아온 데이터 중에서 근처 명소 이미지, 이름, 카테고리를 받아와 StackView에 담는 함수 호출
    //    func configureNearbySpot(nearbySpotImage: String?, nearbySpotTitle: String?, nearbySpotCategory: String?, nearbySpotAdress: String?) {
    //
    //        //nearbySpotStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    //
    //        if let image = nearbySpotImage,
    //           let title = nearbySpotTitle,
    //           let category = nearbySpotCategory,
    //           let address = nearbySpotAdress
    //        {
    //
    //            let nearbySpotStack = createHorizontalNearbyStackView(image: image, title: title, category: category, address: address)
    //
    //            let border = UIView()
    //            border.backgroundColor = .label
    //            border.translatesAutoresizingMaskIntoConstraints = false
    //            border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    //
    //            nearbySpotStackView.addArrangedSubview(nearbySpotStack)
    //            nearbySpotStackView.addArrangedSubview(border)
    //        }
    //    }
    
    
    /// 근처 명소 데이터를 보여주는 UI 설정 함수
    //    func createHorizontalNearbyStackView(image: String?, title: String?, category: String?, address: String?) -> UIStackView {
    //
    //
    //        let stackView = UIStackView()
    //        stackView.axis = .horizontal
    //        stackView.spacing = 10
    //        stackView.alignment = .trailing
    //        stackView.distribution = .fillProportionally
    //        //        stackView.layer.borderWidth = 1
    //        //        stackView.layer.borderColor = UIColor.label.cgColor
    //        stackView.layer.cornerRadius = 10
    //        stackView.clipsToBounds = true
    //        // 패딩 효과를 주는 layoutMargins 설정
    //        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    //        stackView.isLayoutMarginsRelativeArrangement = true // 패딩 적용
    //
    //
    //        var checkImageView = UIImageView()
    //
    //        if let imagePath = image {
    //            let imageView = UIImageView()
    //            imageView.image = UIImage(named: imagePath)
    //            imageView.translatesAutoresizingMaskIntoConstraints = false
    //            imageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
    //            imageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    //            imageView.layer.cornerRadius = 10
    //            imageView.clipsToBounds = true
    //            checkImageView = imageView
    //        }
    //
    //
    //        let titleLabel = UILabel()
    //        titleLabel.text = title
    //        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
    //
    //        let categoryLabel = UILabel()
    //        categoryLabel.text = category
    //        categoryLabel.font = .systemFont(ofSize: 12, weight: .regular)
    //
    //        let addressLabel = UILabel()
    //        addressLabel.text = address
    //        addressLabel.numberOfLines = 0
    //        addressLabel.font = .systemFont(ofSize: 12, weight: .medium)
    //
    //
    //        let findwayButton = UIButton(type: .system)
    //        let findwayconfigure = UIImage.SymbolConfiguration(pointSize: 20)
    //        let findwayimage = UIImage(systemName: "location.circle", withConfiguration: findwayconfigure)
    //        findwayButton.setImage(findwayimage, for: .normal)
    //        findwayButton.tintColor = .label
    //
    //
    //        let shareButton = UIButton(type: .system)
    //        let shareconfigure = UIImage.SymbolConfiguration(pointSize: 20)
    //        let shareimage = UIImage(systemName: "square.and.arrow.up.circle", withConfiguration: shareconfigure)
    //        shareButton.setImage(shareimage, for: .normal)
    //        shareButton.tintColor = .label
    //
    //        let bookMarkButton = UIButton(type: .system)
    //        let bookMarkconfigure = UIImage.SymbolConfiguration(pointSize: 20)
    //        let bookMarkimage = UIImage(systemName: "bookmark.circle", withConfiguration: bookMarkconfigure)
    //        bookMarkButton.setImage(bookMarkimage, for: .normal)
    //        bookMarkButton.tintColor = .label
    //
    //        let spaceView = UIView()
    //        spaceView.widthAnchor.constraint(equalToConstant: 80).isActive = true
    //        spaceView.backgroundColor = .clear
    //
    //        let buttonStackView = UIStackView(arrangedSubviews: [findwayButton, shareButton, bookMarkButton, spaceView])
    //        buttonStackView.axis = .horizontal
    //        buttonStackView.spacing = 20
    //
    //        let labelStackView = UIStackView(arrangedSubviews: [titleLabel, categoryLabel, addressLabel, buttonStackView])
    //        labelStackView.axis = .vertical
    //        labelStackView.spacing = 5
    //
    //        stackView.addArrangedSubview(labelStackView)
    //        stackView.addArrangedSubview(checkImageView)
    //
    //        return stackView
    //    }
    
}


class IntrinsicTableView: UITableView {
    
    override var intrinsicContentSize: CGSize {
        // 현재 섹션에 표시되는 셀의 개수를 계산합니다.
        let numberOfRows = self.numberOfRows(inSection: 0)
        
        // 셀의 고정된 높이 (예: 150)
        let cellHeight: CGFloat = 150.0
        
        // 테이블 뷰의 전체 높이 = 셀 개수 * 셀 높이
        let totalHeight = CGFloat(numberOfRows) * cellHeight
        
        // 테이블 뷰의 컨텐츠 사이즈 설정
        return CGSize(width: self.contentSize.width, height: totalHeight)
    }
    
    // 테이블 뷰의 내용을 리로드할 때마다 intrinsicContentSize가 재계산되도록 트리거
    // 이게 있어야지, 10개의 데이터를 3개씩 나눌때 마지막에 1개인데도 높이가 3개로 계산되지 않는다. 
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
    
}
