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
    
    let bagButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "bag.circle.fill", withConfiguration: configure)
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
        guard let imagePath = item.firstimage, let title = item.title else { return }
        
        let securePosterURL = imagePath.replacingOccurrences(of: "http://", with: "https://")
        
        let url = URL(string: securePosterURL)
        
        spotImage.sd_setImage(with: url)
        spotTitleLabel.text = title
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(spotImage)
        basicView.addSubview(spotTitleLabel)
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
        
        let spotTitleLabelConstraints = [
            spotTitleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            spotTitleLabel.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10),
            spotTitleLabel.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let bagButtonConstraints = [
            bagButton.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            bagButton.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(basicViewConstraints)
        NSLayoutConstraint.activate(spotImageConstraints)
        NSLayoutConstraint.activate(spotTitleLabelConstraints)
        NSLayoutConstraint.activate(bagButtonConstraints)
    }
}
