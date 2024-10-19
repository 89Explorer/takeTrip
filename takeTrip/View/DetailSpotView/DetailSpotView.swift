//
//  DetailSpotView.swift
//  takeTrip
//
//  Created by 권정근 on 10/19/24.
//

import UIKit

class DetailSpotView: UIView {
    
    // MARK: - UI Components
    let basicView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never // Safe Area 인셋 무시
        return view
    }()
    
    /// 디테일 화면에서 헤더에 해당하는 뷰
    let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner,
                                    .layerMaxXMaxYCorner]  // 좌, 우 하단 적용
        return view
    }()
    
    lazy var spotTitleCategoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    let spotTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "평택 메타세콰이어"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let spotCategory: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "공원"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "square.and.arrow.up.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let bagButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "bookmark.circle", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    let detailImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.layer.cornerRadius = 10
        collectionView.clipsToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let spotInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
        return view
    }()
    
    lazy var spotTotalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillProportionally
        stackView.alignment = .center
        return stackView
    }()
    
    let spotAddressImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "location.circle", withConfiguration: configure)
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }()
    
    lazy var spotLabelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    let spotAddressTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "주소"
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let spotAddressValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.text = "경기도 고양시 덕양구 화정동 110번 화졍역 이니스프리"
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    let moveToPageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configure)
        button.setImage(image, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(headerView)
        headerView.addSubview(spotTitleCategoryStackView)
        spotTitleCategoryStackView.addArrangedSubview(spotTitle)
        spotTitleCategoryStackView.addArrangedSubview(spotCategory)
        headerView.addSubview(sharedButton)
        headerView.addSubview(bagButton)
        headerView.addSubview(detailImageCollectionView)
        
        basicView.addSubview(spotInfoView)
        spotInfoView.addSubview(spotTotalStackView)
        spotTotalStackView.addArrangedSubview(spotAddressImage)
        spotTotalStackView.addArrangedSubview(spotLabelStackView)
        spotTotalStackView.addArrangedSubview(moveToPageButton)
        spotLabelStackView.addArrangedSubview(spotAddressTitle)
        spotLabelStackView.addArrangedSubview(spotAddressValue)
                            

        
        let basicViewConstraints = [
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let headerViewConstraints = [
            headerView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: basicView.topAnchor),
            headerView.widthAnchor.constraint(equalTo: basicView.widthAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 470),
        ]
        
        let spotTitleCategoryStackViewConstraints = [
            spotTitleCategoryStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            spotTitleCategoryStackView.topAnchor.constraint(equalTo: headerView.safeAreaLayoutGuide.topAnchor, constant: 10),
            spotTitleCategoryStackView.widthAnchor.constraint(equalToConstant: 150)
        ]
        
        let sharedButtonConstraints = [
            sharedButton.centerYAnchor.constraint(equalTo: spotTitleCategoryStackView.centerYAnchor),
            sharedButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15)
        ]
        
        let bagButtonConstraints = [
            bagButton.centerYAnchor.constraint(equalTo: spotTitleCategoryStackView.centerYAnchor),
            bagButton.trailingAnchor.constraint(equalTo: sharedButton.leadingAnchor, constant: -15)
        ]
        
        let detailImageCollectionViewConstraints = [
            detailImageCollectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15),
            detailImageCollectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -15),
            detailImageCollectionView.topAnchor.constraint(equalTo: spotTitleCategoryStackView.bottomAnchor, constant: 15),
            detailImageCollectionView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let spotInfoViewConstraints = [
            spotInfoView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor),
            spotInfoView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor),
            spotInfoView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10),
            spotInfoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60)
        ]
        
        let spotTotalStackViewConstraints = [
            spotTotalStackView.leadingAnchor.constraint(equalTo: spotInfoView.leadingAnchor, constant: 10),
            spotTotalStackView.trailingAnchor.constraint(equalTo: spotInfoView.trailingAnchor, constant: -10),
            spotTotalStackView.topAnchor.constraint(equalTo: spotInfoView.topAnchor),
            spotTotalStackView.bottomAnchor.constraint(equalTo: spotInfoView.bottomAnchor)
        ]
        
//        let spotLabelStackViewConstraints = [
//            spotLabelStackView.widthAnchor.constraint(equalToConstant: 300)
//        ]
        
        let spotAddressImageConstraints = [
            spotAddressImage.widthAnchor.constraint(equalToConstant: 30),
            spotAddressImage.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let moveToPageButtonConstraints = [
            moveToPageButton.widthAnchor.constraint(equalToConstant: 25),
            moveToPageButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        NSLayoutConstraint.activate(basicViewConstraints)
        NSLayoutConstraint.activate(headerViewConstraints)
        NSLayoutConstraint.activate(spotTitleCategoryStackViewConstraints)
        NSLayoutConstraint.activate(sharedButtonConstraints)
        NSLayoutConstraint.activate(bagButtonConstraints)
        NSLayoutConstraint.activate(detailImageCollectionViewConstraints)
        NSLayoutConstraint.activate(spotInfoViewConstraints)
        NSLayoutConstraint.activate(spotTotalStackViewConstraints)
        //NSLayoutConstraint.activate(spotLabelStackViewConstraints)
        NSLayoutConstraint.activate(spotAddressImageConstraints)
        NSLayoutConstraint.activate(moveToPageButtonConstraints)
        
    }

    
    // MARK: - Functions
    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .label
        return label
    }
    
    func createImageView(text: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let configure = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: text, withConfiguration: configure)
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }

    func createVerticalStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        return stackView
    }
    
    func createHorizontalStackView(arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }
}
