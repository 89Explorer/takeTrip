//
//  DateAddCell.swift
//  takeTrip
//
//  Created by 권정근 on 11/3/24.
//

import UIKit

class DateAddCell: UITableViewCell {
    
    // MARK: - Variables
    static let idenifier: String = "DateAddCell"
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방문 날짜"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        return label
    }()
    
    let selectedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "방문하신 날짜를 선택해주세요"
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .right
        return label
    }()
    
    let rightImageView: UIImageView = {
        let imageView = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }()
    
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(titleLabel)
        basicView.addSubview(selectedDateLabel)
        basicView.addSubview(rightImageView)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        selectedDateLabel.translatesAutoresizingMaskIntoConstraints = false
        rightImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            titleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: basicView.centerYAnchor),
            
            rightImageView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            rightImageView.centerYAnchor.constraint(equalTo: basicView.centerYAnchor),
            rightImageView.heightAnchor.constraint(equalToConstant: 20),
            rightImageView.widthAnchor.constraint(equalToConstant: 20),
            
            selectedDateLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -10),
            selectedDateLabel.centerYAnchor.constraint(equalTo: basicView.centerYAnchor),
            selectedDateLabel.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    // MARK: - Functions
    func updateSelectedDate(with selectedDate: String) {
        selectedDateLabel.text = selectedDate
    }
}
