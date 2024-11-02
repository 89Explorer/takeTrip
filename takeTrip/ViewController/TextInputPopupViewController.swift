//
//  TextInputPopupViewController.swift
//  takeTrip
//
//  Created by 권정근 on 11/1/24.
//

import UIKit

class TextInputPopupViewController: UIViewController {
    
    // MARK: - Variables
    // 입력된 텍스트를 받아오는 변수 추가
    var initialText: String? {
        didSet {
            textView.text = initialText
            textView.textColor = .black
        }
    }

    // UI 요소 설정
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .lightGray
        textView.text = "여행 소감을 남겨주세요."
        textView.backgroundColor = .secondarySystemBackground
        textView.isScrollEnabled = true
        return textView
    }()

    let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("적용", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    var onApply: ((String) -> Void)?
    private var totalStackBottomConstraint: NSLayoutConstraint? // textView 하단 제약 조건

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
 
        setupKeyboardNotifications() // 키보드 알림 설정
        configureConstraints()

        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        textView.delegate = self // 텍스트 뷰 델리게이트 설정
    }

    // UI 레이아웃 설정
    private func configureConstraints() {
        view.addSubview(basicView)
        basicView.addSubview(totalStackView)
        totalStackView.addArrangedSubview(textView)
        totalStackView.addArrangedSubview(applyButton)
       
        basicView.translatesAutoresizingMaskIntoConstraints = false
        totalStackView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false

        
        // totalStackView 하단에 제약조건을 나중에 수정하여 사용할 수 있도록 하기 위함 
        let bottomConstarints = totalStackView.bottomAnchor.constraint(equalTo: basicView.bottomAnchor, constant: -100)
        totalStackBottomConstraint = bottomConstarints

        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: view.topAnchor),
            basicView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            totalStackView.topAnchor.constraint(equalTo: basicView.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalStackView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 20),
            totalStackView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -20),
            totalStackBottomConstraint!,
            
            // textView.heightAnchor.constraint(equalToConstant: 450),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // 키보드 노티피케이션 설정
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // 키보드가 나타날 때 호출되는 함수
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        totalStackBottomConstraint?.constant = -(keyboardHeight + 30) // 키보드 위 30 포인트 간격 설정

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // 키보드가 사라질 때 호출되는 함수
    @objc private func keyboardWillHide(notification: Notification) {
        totalStackBottomConstraint?.constant = -100 // 원래 위치로 복귀

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // 적용 버튼 동작
    @objc private func applyButtonTapped() {
        onApply?(textView.text)
        dismiss(animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self) // 노티피케이션 해제
    }
}

// UITextViewDelegate 구현
extension TextInputPopupViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "여행 소감을 남겨주세요."
            textView.textColor = .lightGray
        }
    }
}



//import UIKit
//
//class TextInputPopupViewController: UIViewController {
//    
//    // MARK: - Variables
//    var onApply: ((String) -> Void)?
//    private var popupViewBottomConstraint: NSLayoutConstraint?
//    
//    // MARK: - UI Components
//    let textView: UITextView = {
//        let textView = UITextView()
//        textView.font = UIFont.systemFont(ofSize: 16)
//        textView.textColor = .lightGray
//        textView.text = "공간에서의 경험이나 정보를 자세히 작성할수록 다른 데이터리퍼에게 큰 도움이 될 거예요."
//        textView.backgroundColor = .clear
//        return textView
//    }()
//    
//    let applyButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("적용", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .black
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        return button
//    }()
//    
//    
//    // MARK: - Initializations
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
//        
//        // 텍스트 뷰 플레이스홀더 설정
//        textView.delegate = self
//        configureConstraints()
//    }
//    
//    // MARK: - Layouts
//    private func configureConstraints() {
//        let containerView = UIView()
//        containerView.backgroundColor = .white
//        containerView.layer.cornerRadius = 12
//        containerView.clipsToBounds = true
//        
//        view.addSubview(containerView)
//        containerView.addSubview(textView)
//        containerView.addSubview(applyButton)
//        
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        applyButton.translatesAutoresizingMaskIntoConstraints = false
//        
//        popupViewBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
//        
//        NSLayoutConstraint.activate([
//            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            popupViewBottomConstraint!,
//            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            textView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
//            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
//            textView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
//            textView.heightAnchor.constraint(equalToConstant: 150),
//            
//            applyButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
//            applyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
//            applyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
//            applyButton.heightAnchor.constraint(equalToConstant: 50),
//            applyButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
//        ])
//    }
//    
//    private func setupKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    @objc private func keyboardWillShow(notification: Notification) {
//        guard let userInfo = notification.userInfo,
//              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//        
//        let keyboardHeight = keyboardFrame.height
//        popupViewBottomConstraint?.constant = -(keyboardHeight + 10) // 키보드 위 10포인트 간격으로 설정
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    @objc private func keyboardWillHide(notification: Notification) {
//        popupViewBottomConstraint?.constant = -30 // 원래 위치로 복귀
//        
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    @objc private func applyButtonTapped() {
//        onApply?(textView.text)
//        dismiss(animated: true, completion: nil)
//    }
//    
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//    
//    
//}
//
//extension TextInputPopupViewController: UITextViewDelegate {
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == .lightGray {
//            textView.text = ""
//            textView.textColor = .black
//        }
//    }
//    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "공간에서의 경험이나 정보를 자세히 작성할수록 다른 데이터리퍼에게 큰 도움이 될 거예요."
//            textView.textColor = .lightGray
//        }
//    }
//}
