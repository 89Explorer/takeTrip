//
//  ProfileCollectionCell.swift
//  takeTrip
//
//  Created by 권정근 on 11/10/24.
//

import UIKit

class ProfileCollectionCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "ProfileCollectionCell"
    
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "작성한 피드"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .label
        view.isHidden = true
        return view
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
        basicView.addSubview(titleLabel)
        basicView.addSubview(underLine)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        underLine.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 10),
            
            
            underLine.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            underLine.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            underLine.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            underLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    
    // MARK: - Functions
    func updateTitleLabel(with title: String) {
        titleLabel.text = title
    }
}
