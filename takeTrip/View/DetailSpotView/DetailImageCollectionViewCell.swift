//
//  DetailImageCollectionViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/20/24.
//

import UIKit
import SDWebImage

class DetailImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    static let identifier = "DetailImageCollectionViewCell"
    
    
    let detailImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "korea")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(detailImage)
        
        let detailImageConstraints = [
            detailImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailImage.topAnchor.constraint(equalTo: topAnchor),
            detailImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(detailImageConstraints)
    }
    
    // MARK: - Functions
    func getDetailImage(with imageURL: String) {
        
        let securePosterURL = imageURL.replacingOccurrences(of: "http://", with: "https://")
        
        if let url = URL(string: securePosterURL) {
            detailImage.sd_setImage(with: url)
        } else {
            detailImage.image = UIImage(systemName: "house.fill")
        }
    }
    
    func getUserImage(with images: UIImage) {
        
        detailImage.image = images
        
    }
}
