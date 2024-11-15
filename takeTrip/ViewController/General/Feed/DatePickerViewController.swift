//
//  DatePickerViewController.swift
//  takeTrip
//
//  Created by 권정근 on 11/4/24.
//

import UIKit

class DatePickerViewController: UIViewController {

    // MARK: - Variables
    var onDateSelected: ((Date) -> Void)?    // 선택된 날짜를 전달할 클로저
    var initialDate: Date?    // 초기 날짜를 설정할 변수
    
    // MARK: - UI Components
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "방문하신 날짜를 선택해주세요"
        label.font = .systemFont(ofSize: 20, weight: .black)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date   // 하루만 선택 가능하게 설정
        picker.preferredDatePickerStyle = .inline
        picker.date = Date()   // 기본적으로 활성화
        return picker
    }()
    
    let selectedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = false
        return button
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(datePicker)
        view.addSubview(selectedButton)
        
        configureContraints()
        
        datePicker.addTarget(self, action: #selector(changedDate), for: .valueChanged)
        selectedButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let initialDate = initialDate {
            datePicker.date = initialDate
            selectedButton.isEnabled = true
        }
    }
    
    // MARK: - Layouts
    private func configureContraints() {
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(selectedButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        selectedButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            selectedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            selectedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            selectedButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 10),
            selectedButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
    
    
    // MARK: - Actions
    @objc private func selectButtonTapped() {
        onDateSelected?(datePicker.date) // 선택한 날짜 전달
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func changedDate() {
        selectedButton.isEnabled = true
    }
}
