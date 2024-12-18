//
//  spotResultsTableViewCell.swift
//  takeTrip
//
//  Created by 권정근 on 10/30/24.
//

import UIKit
import SDWebImage

class spotResultsTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier = "spotResultsTableViewCell"
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        return view
    }()
    
    let imageTitleStaciView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    let searchImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "korea")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "고양시 어린이 체험관"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "경기, 고양시"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    
    let categoryLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.text = "문화시설"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.textColor = .white
        label.backgroundColor = .systemGray
        return label
    }()
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        addSubview(basicView)
        basicView.addSubview(imageTitleStaciView)
        imageTitleStaciView.addArrangedSubview(searchImage)
        imageTitleStaciView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(addressLabel)
        titleStackView.addArrangedSubview(categoryLabel)
        
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        imageTitleStaciView.translatesAutoresizingMaskIntoConstraints = false
        searchImage.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            // basivView 오토레이아웃 설정
            basicView.leadingAnchor.constraint(equalTo: leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: trailingAnchor),
            basicView.topAnchor.constraint(equalTo: topAnchor),
            basicView.bottomAnchor.constraint(equalTo: bottomAnchor),
        
            // imageTitelStackView 오토레이아웃 설정
            imageTitleStaciView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            imageTitleStaciView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            imageTitleStaciView.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 5),
            imageTitleStaciView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -5),
//            imageTitleStaciView.widthAnchor.constraint(equalTo: basicView.widthAnchor),
            
            // searchImage의 가로, 세로 크기 설정 
            searchImage.widthAnchor.constraint(equalToConstant: 120),
            searchImage.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // MARK: - Functions
    /// AttractionItem 타입의 item이라는 데이터를 받아옴
    func configureSearchData(with item: AttractionItem) {
        guard let imagePath = item.firstimage,
              let title = item.title,
              let address = item.addr1
        else { return }
        
        let securePosterURL = imagePath.replacingOccurrences(of: "http://", with: "https://")
        
        if let url = URL(string: securePosterURL) {
            searchImage.sd_setImage(with: url)
        } else {
            searchImage.image = UIImage(systemName: "square.slash")
        }
        
        let modifiedAddress = getAddressPrefix(fullAddress: address, wordCount: 2)
        
        titleLabel.text = title
        addressLabel.text = modifiedAddress
        
        self.fetchCategory(with: item) { [weak self] result in
            DispatchQueue.main.async {
                self?.categoryLabel.text = result
            }
        }
    }
    
    /// 띄어쓰기로 문자열 구분
    func getAddressPrefix(fullAddress: String, wordCount: Int) -> String {
        let components = fullAddress.split(separator: " ")  // 띄어쓰기 기준으로 문자열 분리
        let prefix = components.prefix(wordCount)          // 원하는 단어 개수만큼 가져옴
        return prefix.joined(separator: " ")               // 다시 띄어쓰기로 합침
    }
    
    
    func fetchCategory(with item: AttractionItem, completion: @escaping (String) -> Void) {
        guard let cat1 = item.cat1,
              let cat2 = item.cat2,
              let cat3 = item.cat3,
              let contenttypeid = item.contenttypeid else { return }
        
        NetworkManager.shared.fetchCategoryCode(contentTypeId: contenttypeid, cat1: cat1, cat2: cat2, cat3: cat3) { results in
            switch results {
            case .success(let category):
                let name = category.response.body.items.item[0].name ?? "기타"
                completion(name)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}


class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8) // 원하는 패딩

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        let originalSize = super.intrinsicContentSize
        let width = originalSize.width + textInsets.left + textInsets.right
        let height = originalSize.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }
}
