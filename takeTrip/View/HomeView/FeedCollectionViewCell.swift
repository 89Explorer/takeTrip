//
//  FeedCollectionViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit
import SDWebImage

class FeedCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "FeedCollectionViewCell"
    
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let spotImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "korea")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let spotTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "경복궁"
        label.textAlignment = .left
        label.numberOfLines = 0
        //label.font = UIFont(name: "YeongdoOTF-Heavy", size: 10)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    
    lazy var spotAddressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    
    let spotAddressImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 10)
        let image = UIImage(systemName: "location.circle", withConfiguration: configure)
        imageView.image = image
        imageView.tintColor = .white
        return imageView
    }()
    
    
    let spotAddressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "경기, 시흥시"
        label.textAlignment = .left
        label.numberOfLines = 0
        //label.font = UIFont(name: "YeongdoOTF-Heavy", size: 10)
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .white
        return label
    }()
    
    let bagButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "bookmark.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Functions
    /// 각 컬렉션셀에 설정하는 함수
    func configureCollectionViewCell(with item: AttractionItem) {
        guard let imagePath = item.firstimage, let title = item.title, let address = item.addr1 else { return }
        
        let securePosterURL = imagePath.replacingOccurrences(of: "http://", with: "https://")
        
        let url = URL(string: securePosterURL)
        
        let modifiedAddress = getAddressPrefix(fullAddress: address, wordCount: 2)
        
        spotImage.sd_setImage(with: url)
        spotTitleLabel.text = title
        
        if !modifiedAddress.isEmpty {
            spotAddressLabel.text = modifiedAddress
        } else {
            spotAddressLabel.text = nil
            spotAddressImage.image = nil
        }
    }
    
    // 띄어쓰기로 문자열 구분
    func getAddressPrefix(fullAddress: String, wordCount: Int) -> String {
        let components = fullAddress.split(separator: " ")  // 띄어쓰기 기준으로 문자열 분리
        let prefix = components.prefix(wordCount)          // 원하는 단어 개수만큼 가져옴
        return prefix.joined(separator: " ")               // 다시 띄어쓰기로 합침
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(spotImage)
        basicView.addSubview(spotTitleLabel)
        basicView.addSubview(spotAddressStackView)
        
        spotAddressStackView.addArrangedSubview(spotAddressImage)
        spotAddressStackView.addArrangedSubview(spotAddressLabel)
        //        basicView.addSubview(spotAddressImage)
        //        basicView.addSubview(spotAddressLabel)
        basicView.addSubview(bagButton)
        
        let basicViewConstraints = [
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let spotImageConstraints = [
            spotImage.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            spotImage.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            spotImage.topAnchor.constraint(equalTo: basicView.topAnchor),
            spotImage.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
        ]
        
        let spotAddressStackViewConstraints = [
            spotAddressStackView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            spotAddressStackView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10),
            spotAddressStackView.widthAnchor.constraint(equalToConstant: 150),
            spotAddressStackView.heightAnchor.constraint(equalToConstant: 12)
        ]
        
        let spotTitleLabelConstraints = [
            spotTitleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            spotTitleLabel.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -25),
            spotTitleLabel.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let bagButtonConstraints = [
            bagButton.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            bagButton.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(basicViewConstraints)
        NSLayoutConstraint.activate(spotImageConstraints)
        NSLayoutConstraint.activate(spotAddressStackViewConstraints)
        NSLayoutConstraint.activate(spotTitleLabelConstraints)
        NSLayoutConstraint.activate(bagButtonConstraints)
    }
}
