//
//  FeedCollectionViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

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
        label.font = UIFont(name: "Yeongdo-Heavy", size: 16)
        //label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        return label
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
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(spotImage)
        basicView.addSubview(spotTitleLabel)
        
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
        
        NSLayoutConstraint.activate(basicViewConstraints)
        NSLayoutConstraint.activate(spotImageConstraints)
        NSLayoutConstraint.activate(spotTitleLabelConstraints)
    }
}
