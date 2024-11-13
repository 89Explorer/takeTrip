//
//  FeedTableCell.swift
//  takeTrip
//
//  Created by 권정근 on 11/10/24.
//

import UIKit

class FeedTableCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier: String = "FeedTableCell"
    
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    
    let feedTotalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    
    let feedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "korea")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let feedLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    
    let feedTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은 이 날입니다."
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
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
    
    
    let feedLocationLabel: UILabel = {
        let label = UILabel()
        label.text = "고양 어린이 박물관"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    
    let feedLocationCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = "박물관"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let feedCategoryLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "드라이브 🚗"
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.backgroundColor = .black
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(feedTotalStackView)
        feedTotalStackView.addArrangedSubview(feedImageView)
        feedTotalStackView.addArrangedSubview(feedLabelStackView)
        feedLabelStackView.addArrangedSubview(feedTitleLabel)
        feedLabelStackView.addArrangedSubview(feedDateLabel)
        feedLabelStackView.addArrangedSubview(feedLocationLabel)
        feedLabelStackView.addArrangedSubview(feedCategoryLabel)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        feedTotalStackView.translatesAutoresizingMaskIntoConstraints = false
        feedImageView.translatesAutoresizingMaskIntoConstraints = false
        feedLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        feedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        feedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        feedLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        feedCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            feedTotalStackView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 5),
            feedTotalStackView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -5),
            feedTotalStackView.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 5),
            feedTotalStackView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -5),
            
            feedImageView.widthAnchor.constraint(equalToConstant: 140),
            feedImageView.heightAnchor.constraint(equalToConstant: 140),
        ])
    }
    
    // MARK: - Functions
    func configure(with feedItem: FeedItem) {
        feedTitleLabel.text = feedItem.tripLog
        feedDateLabel.text = feedItem.date != nil ? DateFormatter.localizedString(from: feedItem.date!, dateStyle: .medium, timeStyle: .none) : "날짜 없음"
        feedLocationLabel.text = feedItem.location
        feedCategoryLabel.text = feedItem.category ?? ""
        
        if let firstImage = feedItem.images?.first {
            feedImageView.image = firstImage
            print(firstImage)
        } else {
            feedImageView.image = UIImage(named: "placeholder") // 기본 이미지 설정
        }
    }
}
