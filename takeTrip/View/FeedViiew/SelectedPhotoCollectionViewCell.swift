//
//  SelectedPhotoCollectionViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 11/8/24.
//

import UIKit

class SelectedPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "SelectedPhotoCollectionViewCell"
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    var selectedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "korea")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let removeImageButton: UIButton = {
        let button = UIButton()
        let configure = UIImage.SymbolConfiguration(pointSize: 20)
        let image = UIImage(systemName: "x.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .black
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
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(selectedImage)
        basicView.addSubview(removeImageButton)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        selectedImage.translatesAutoresizingMaskIntoConstraints = false
        removeImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectedImage.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            selectedImage.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            selectedImage.topAnchor.constraint(equalTo: basicView.topAnchor),
            selectedImage.bottomAnchor.constraint(equalTo: basicView.bottomAnchor),
            
            removeImageButton.trailingAnchor.constraint(equalTo: selectedImage.trailingAnchor),
            removeImageButton.topAnchor.constraint(equalTo: selectedImage.topAnchor)
        ])
    }
}
