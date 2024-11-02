//
//  TextInputCell.swift
//  takeTrip
//
//  Created by 권정근 on 11/1/24.
//

import UIKit

class TextInputCell: UITableViewCell {
    
    // MARK: - Variables
    static let identifier: String = "TextInputCell"
    weak var delegate: TextInputCellDelegate?
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let feedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0 // 여러 줄 설정
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.text = "다녀오신 여행소감을 남겨주세요"
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        
        configureConstraints()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.didTapTextInputCell(in: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        contentView.addSubview(basicView)
        basicView.addSubview(feedLabel)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        feedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            basicView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            feedLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            feedLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            feedLabel.topAnchor.constraint(equalTo: basicView.topAnchor),
            feedLabel.bottomAnchor.constraint(equalTo: basicView.bottomAnchor)
        ])
    }
    
    // MARK: - Functions
    private func configureCellText() {
        textLabel?.text = "다녀오신 여행소감을 남겨주세요 😀"
    }
}

// TextInputCell의 버튼이나 셀을 눌렀을 때 팝업을 띄우기 위한 델리게이트 프로토콜 생성
protocol TextInputCellDelegate: AnyObject {
    func didTapTextInputCell(in cell: TextInputCell)
}
