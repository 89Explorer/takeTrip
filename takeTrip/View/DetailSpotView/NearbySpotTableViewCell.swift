//
//  NearbySpotTableViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/20/24.
//

import UIKit
import SDWebImage

class NearbySpotTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "NearbySpotTableViewCell"
    
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var nearbySpotTotalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var nearbySpotLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    let nearbySpotName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.text = "한국 박물관"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let nearbySpotCategory: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)

        label.text = "박물관"
        label.backgroundColor = .secondarySystemBackground
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
//    lazy var nearbyButtonStack: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 20
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        return stackView
//    }()
    
    let nearbySpotAddressButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "location.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let nearbySpotShareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "square.and.arrow.up.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let nearbySpotBookMarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "bookmark.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let nearbySpotAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.text = "경기도 고양시 덕양구 고잔동 222-3번지 이니스프리"
        label.numberOfLines = 0
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let nearbySpotDistance: PaddedLabel = {
        let label = PaddedLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "223m"
        label.backgroundColor = .secondarySystemBackground
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let nearbySpotImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "korea")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    
    let borderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .label
        return view
    }()
    
    
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // contentView 패딩 효과 적용 -> 셀 간의 구분을 주기 위함 
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0))
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(nearbySpotTotalStack)
        nearbySpotTotalStack.addArrangedSubview(nearbySpotLabelStack)
        nearbySpotTotalStack.addArrangedSubview(nearbySpotImage)
        
        nearbySpotLabelStack.addArrangedSubview(nearbySpotName)
        nearbySpotLabelStack.addArrangedSubview(nearbySpotCategory)
        nearbySpotLabelStack.addArrangedSubview(nearbySpotAddress)
        nearbySpotLabelStack.addArrangedSubview(nearbySpotDistance)
        //nearbySpotLabelStack.addArrangedSubview(nearbyButtonStack)
        
        //nearbyButtonStack.addArrangedSubview(nearbySpotAddressButton)
        //nearbyButtonStack.addArrangedSubview(nearbySpotShareButton)
        //nearbyButtonStack.addArrangedSubview(nearbySpotBookMarkButton)
        
        let basicViewConstraints = [
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let nearbySpotTotalStackConstraints = [
            nearbySpotTotalStack.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            nearbySpotTotalStack.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            nearbySpotTotalStack.topAnchor.constraint(equalTo: basicView.topAnchor),
            nearbySpotTotalStack.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
        ]
        
        let nearbySpotImageConstraints = [
            nearbySpotImage.widthAnchor.constraint(equalToConstant: 140),
            nearbySpotImage.heightAnchor.constraint(equalToConstant: 140)
        ]
        
        
        NSLayoutConstraint.activate(basicViewConstraints)
        NSLayoutConstraint.activate(nearbySpotTotalStackConstraints)
        NSLayoutConstraint.activate(nearbySpotImageConstraints )
    }
    
    
    // MARK: - Functions
    func configureTableView(with item: AttractionItem?) {
        
        guard let title = item?.title,
              let address = item?.addr1,
              let spotCategory = item?.cat3,
              let imagePath = item?.firstimage else { return }
        
        if let categoryEnum = ThirdCategory(rawValue: spotCategory) {
            self.nearbySpotCategory.text = categoryEnum.displayName
        } else {
            self.nearbySpotCategory.text = ""
        }
        
        nearbySpotName.text = title
        nearbySpotAddress.text = address
        
        let securePosterURL = imagePath.replacingOccurrences(of: "http://", with: "https://")
        
        if let url = URL(string: securePosterURL) {
            nearbySpotImage.sd_setImage(with: url)
        } else {
            nearbySpotImage.image = UIImage(named: "korea")
        }
        
        guard let distance = item?.dist else { return }
        let newDis = formatDistanceToMessage(distance: distance)
        nearbySpotDistance.text = newDis
    }
    
    /// 소숫점으로 표시된 거리를 문자열로 변환해주는 함수
    func formatDistanceToMessage(distance: String) -> String {
        // 소수점 반올림하여 정수로 변환
        guard let newValue = Double(distance) else { return "0" }
        let roundedDistance = Int(round(newValue))
        // 결과 메시지 생성
        return "이 곳에서 반경 \(roundedDistance)m 이내"
    }
}
