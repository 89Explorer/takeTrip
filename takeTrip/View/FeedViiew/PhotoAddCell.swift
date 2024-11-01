//
//  PhotoAddCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/31/24.
//

import UIKit

class PhotoAddCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "PhotoAddCell"
    weak var delegate: PhotoAddCellDelegate?
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let imageSelectedButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.baseBackgroundColor = .systemBackground
        configuration.baseForegroundColor = .label
    
        // configuration.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        configuration.title = "Add Photo"
        configuration.subtitle = "최대 10장 선택 가능"
        configuration.attributedTitle?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        configuration.attributedSubtitle?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        configuration.titleAlignment = .center
        
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "photo.circle", withConfiguration: configure)
        
        configuration.image = image
        configuration.imagePlacement = .top
        configuration.imagePadding = 5
        
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground

        configureContraints()
        imageSelectedButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureContraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(imageSelectedButton)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        imageSelectedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            imageSelectedButton.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            imageSelectedButton.centerYAnchor.constraint(equalTo: basicView.centerYAnchor),
            imageSelectedButton.heightAnchor.constraint(equalToConstant: 180),
            imageSelectedButton.widthAnchor.constraint(equalToConstant: 140)
        ])
    }
    
    // MARK: - Functions
    func imageSelectedButtonTapped() {
        imageSelectedButton.addTarget(self, action: #selector(addimageButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func addimageButtonTapped() {
        print("Button Tapped")
        delegate?.didTapAddPhotoButton(in: self)
    }
}


// MARK: - Protocol
/// 버튼 액션을 전달하기 위해 Delegate 프로토콜 생성
protocol PhotoAddCellDelegate: AnyObject {
    func didTapAddPhotoButton(in cell: PhotoAddCell)
    func photoAddCell(_ cell: PhotoAddCell, didSelectImages images: [UIImage])
}

