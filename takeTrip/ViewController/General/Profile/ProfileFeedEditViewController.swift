//
//  ProfileFeedEditViewController.swift
//  takeTrip
//
//  Created by 권정근 on 11/15/24.
//

import UIKit

class ProfileFeedEditViewController: UIViewController {
    
    // MARK: - Variables
    var feedDataManager = FeedDataManager()
    var userFeed: FeedItem?
    
    weak var delegate: ProfileFeedEditDelegate?
    
    // MARK: - UI Components
    let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("수정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    let deletButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("닫기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .secondarySystemBackground
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureConstraints()
        
        didTappedButtons()
    }
    
    // MARK - Layouts
    private func configureConstraints() {
        view.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(editButton)
        buttonStackView.addArrangedSubview(deletButton)
        buttonStackView.addArrangedSubview(closeButton)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        editButton.translatesAutoresizingMaskIntoConstraints = false
        deletButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    // MARK: - Functions
    func didTappedButtons() {
        closeButton.addTarget(self, action: #selector(didCalledCloseButton), for: .touchUpInside)
        deletButton.addTarget(self, action: #selector(didCalledDeleteButton), for: .touchUpInside)
    }
    
    
    // MARK: - Actions
    @objc func didCalledCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func didCalledDeleteButton() {
        print("데이터 삭제 완료")
        feedDataManager.deleteFeedItem(feedID: userFeed!.feedID)
        delegate?.didDeleteFeed()
        dismiss(animated: true)
//        dismiss(animated: true) {
//            // NotificationCenter를 통해 삭제 알림 전송
//            NotificationCenter.default.post(name: NSNotification.Name("DeleteItemNotification"), object: nil)
//        }
        
    }
}


// 삭제 작업을 완료한 후 ProfileViewController로 돌아가도록 알리는 Delegate를 정의
protocol ProfileFeedEditDelegate: AnyObject {
    func didDeleteFeed()
}
