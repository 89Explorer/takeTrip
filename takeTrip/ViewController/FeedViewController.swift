//
//  FeedViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit
import PhotosUI

class FeedViewController: UIViewController {
    
    
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
        button.isEnabled = false // 초기에는 button 비활성화
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
        navigationItem.title = "여행로그 작성"
        navigationController?.navigationBar.tintColor = .label
    }
    
    func setupTableView() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        feedTableView.register(PhotoAddCell.self, forCellReuseIdentifier: PhotoAddCell.identifier)
        feedTableView.register(TextInputCell.self, forCellReuseIdentifier: TextInputCell.identifier)
        feedTableView.register(SpaceAddCell.self, forCellReuseIdentifier: SpaceAddCell.identifier)
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "방문날짜 추가 셀"
            return cell
        case (2, 2):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "커뮤니티 추가 셀"
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
            
            if let sheet = spaceSearchVC.sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
            }
            
            // 선택했을 때의 동작
            spaceSearchVC.onSelectspace = { [weak self] item in
                guard let cell = tableView.cellForRow(at: indexPath) as? SpaceAddCell else { return }
                cell.updateSelectedSpace(with: item)
            }
            
            present(spaceSearchVC, animated: true)
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
        print("선택된 이미지 개수: \(images.count)")
    }
}

extension FeedViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let imageItems = results.prefix(10)
        var selectedImages = [UIImage]()
        
        let group = DispatchGroup()
        
        for item in imageItems {
            group.enter()
            item.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                if let image = object as? UIImage {
                    selectedImages.append(image)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if let cell = self.feedTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? PhotoAddCell {
                self.photoAddCell(cell, didSelectImages: selectedImages)
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
            self?.feedTableView.reloadData()
        }
        
        present(textInputPopupVC, animated: true, completion: nil)
    }
}
