//
//  FeedViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit
import PhotosUI

class FeedViewController: UIViewController {
    
    // MARK: - Variables
    var selectedDate: Date?
    var selectedCategories: [String]?
    
    var selectedImages: [UIImage] = []     // 선택된 이미지를 담는 배열
    
    var feedDataManager = FeedDataManager()
    var selectedTripLog: String = ""
    var selectedLocation: String = ""
    
    
    // MARK: - UI Components
    let feedTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondarySystemBackground
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("데이피드 업로드", for: .normal)
        button.setTitleColor(.lightGray, for: .disabled)
        button.isEnabled = true // 초기에는 button 비활성화
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupNavigationBar()
        setupTableView()
        
        configureConstraints()
        
        uploadButton.addTarget(self, action: #selector(didTappedUploadButton), for: .touchUpInside)
        
    }

    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(feedTableView)
        view.addSubview(uploadButton)
        
        feedTableView.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -5),
            
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            uploadButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    
    // MARK: - Functions
    func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Trip Log"
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 28, weight: .black)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }    
    
    func setupTableView() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        feedTableView.register(PhotoAddCell.self, forCellReuseIdentifier: PhotoAddCell.identifier)
        feedTableView.register(TextInputCell.self, forCellReuseIdentifier: TextInputCell.identifier)
        feedTableView.register(SpaceAddCell.self, forCellReuseIdentifier: SpaceAddCell.identifier)
        feedTableView.register(DateAddCell.self, forCellReuseIdentifier: DateAddCell.idenifier)
        feedTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    
    func saveCurrentFeedItem() {
        // 현재 뷰에서 입력된 데이터를 FeedItem 구조체 담음
        let feedItem = FeedItem(
            images: selectedImages,
            tripLog: selectedTripLog,
            location: selectedLocation,
            date: selectedDate,
            category: selectedCategories?.joined())
        
        // 데이터 저장 호출
        feedDataManager.saveFeedItem(feedItem: feedItem)
    }
    
    func loadFeedItems() {
        let savedFeedItems = feedDataManager.fetchFeedItems()
        
        for item in savedFeedItems {
            print("로드된 아이템: \(item)")
        }
    }
    
    
    @objc func didTappedUploadButton() {
        saveCurrentFeedItem()
        
        // 선택한 값 초기화
        selectedTripLog = ""
        selectedLocation = ""
        selectedImages = []
        selectedDate = nil
        selectedCategories = []
        
        // UI 초기화
        resetUI()
        
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 4
        }
    }
    
    func resetUI() {
        if let photoCell = feedTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PhotoAddCell {
            photoCell.updateImage([])
        }
        
        if let textCell = feedTableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TextInputCell {
            textCell.feedLabel.text = "텍스트를 입력하세요 "
        }
        
        if let spaceCell = feedTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? SpaceAddCell {
            spaceCell.updateSelectedSpace(with: "장소를 선택하세요")
        }
        
        if let dateCell = feedTableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? DateAddCell {
            dateCell.selectedDateLabel.text = "날짜를 선택하세요"
        }
        
        if let categoryCell = feedTableView.cellForRow(at: IndexPath(row: 2, section: 2)) as? CategoryTableViewCell {
            categoryCell.selectedCategoryLabel.text = "카테고리를 선택하세요"
        }
        
        feedTableView.reloadData()
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):   // 사진 추가 셀
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoAddCell.identifier, for: indexPath) as? PhotoAddCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case (1, 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TextInputCell.identifier, for: indexPath) as? TextInputCell else { return UITableViewCell() }
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
        case (2, 0):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceAddCell.identifier, for: indexPath) as? SpaceAddCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            return cell
        case (2, 1):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DateAddCell.idenifier, for: indexPath) as? DateAddCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            return cell
        case (2, 2):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 220
        case 1:
            return 200
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            let spaceSearchVC = SpaceSearchViewController()
            spaceSearchVC.modalPresentationStyle = .pageSheet
            
            // Sheet 형식을 사용
            if let sheet = spaceSearchVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            // 선택했을 때의 동작
            spaceSearchVC.onSelectspace = { [weak self] item in
                guard let cell = tableView.cellForRow(at: indexPath) as? SpaceAddCell else { return }
                self?.selectedLocation = item
                cell.updateSelectedSpace(with: item)
            }
            
            present(spaceSearchVC, animated: true)
        }
        
        if indexPath.section == 2 && indexPath.row == 1 {
            let datePickerVC = DatePickerViewController()
            datePickerVC.modalPresentationStyle = .pageSheet
            
            // 초기 날짜를 설정하여 DatePicker 초기화
            if let currentSelectedDate = selectedDate { // 이미 선택된 날짜가 있으면 사용
                datePickerVC.initialDate = currentSelectedDate
            } else { // 선택된 날짜가 없다면 기본값을 오늘로 설정
                datePickerVC.initialDate = Date()
            }
            
            if let sheet = datePickerVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            // 날짜 선택 시 동작
            datePickerVC.onDateSelected = { [weak self] selectedDate in
                guard let self = self else { return }
                self.selectedDate = selectedDate // 새로운 날짜 저장
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: selectedDate)
                
                guard let cell = tableView.cellForRow(at: indexPath) as? DateAddCell else { return }
                cell.selectedDateLabel.text = dateString
            }
            present(datePickerVC, animated: true)
        }
        
        if indexPath.section == 2 && indexPath.row == 2 { // 카테고리 선택 셀을 눌렀을 때
            let categorySheetVC = CategorySheetViewController()
            categorySheetVC.modalPresentationStyle = .pageSheet
            
            if let sheet = categorySheetVC.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
            }
            
            // 카테고리 선택 시 호출될 클로저
            categorySheetVC.onCategoriesSelected = { [weak self] selectedCategories in
                guard let self = self else { return }
                
                // 선택된 카테고리를 self.selectedCategories에 저장
                self.selectedCategories = selectedCategories
                
                guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
                
                cell.selectedCategoryLabel.text = selectedCategories.joined(separator: ", ")

            }
            
            present(categorySheetVC, animated: true, completion: nil)
        }
        
    }
}

extension FeedViewController: PhotoAddCellDelegate {
    
    func didTapAddPhotoButton(in cell: PhotoAddCell) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 10 // 최대 선택 개수 설정
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func photoAddCell(_ cell: PhotoAddCell, didSelectImages images: [UIImage]) {
        // 선택된 이미지를 PhotoAddCell에 전달하여 UI 업데이트
        cell.updateImage(images)
        
    }
}

extension FeedViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let imageItems = results.prefix(10)
        selectedImages = []
        
        let group = DispatchGroup()
        
        for item in imageItems {
            group.enter()
            item.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    self.selectedImages.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let cell = self.feedTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PhotoAddCell {
                self.photoAddCell(cell, didSelectImages: self.selectedImages)
            }
        }
    }
}


extension FeedViewController: TextInputCellDelegate {
    
    func didTapTextInputCell(in cell: TextInputCell) {
        let textInputPopupVC = TextInputPopupViewController()
        textInputPopupVC.modalPresentationStyle = .popover
        textInputPopupVC.modalTransitionStyle = .crossDissolve
        
        // 현재 셀의 텍스트를 초기 텍스트로 설정
        textInputPopupVC.initialText = cell.feedLabel.text
        
        textInputPopupVC.onApply = { [weak self] inputText in
            // print("입력된 텍스트: \(inputText)")
            // 입력된 텍스트를 저장하거나 처리하는 로직 추가
            cell.feedLabel.text = inputText
            self?.selectedTripLog = inputText
            self?.feedTableView.reloadData()
        }
        
        present(textInputPopupVC, animated: true, completion: nil)
    }
}


