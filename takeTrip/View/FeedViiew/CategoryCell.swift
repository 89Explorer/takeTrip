//
//  CategoryCell.swift
//  takeTrip
//
//  Created by 권정근 on 11/6/24.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier: String = "CategoryCell"
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.label.cgColor
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1 // 한 줄로 제한
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(basicView)
        basicView.addSubview(categoryLabel)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            categoryLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            categoryLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            categoryLabel.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 10),
            categoryLabel.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    func configure(with text: String) {
        categoryLabel.text = text
    }
}
