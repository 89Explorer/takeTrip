//
//  CategorySheetViewController.swift
//  takeTrip
//
//  Created by 권정근 on 11/6/24.
//

import UIKit

class CategorySheetViewController: UIViewController {
    
    // MARK: - Variables
    private let categories = ["반려동물 🐶", "애인 💑", "가족 👫", "아이 👶", "여행 🛫", "커피 ☕️","차 🫖","알코올 🚰", "드라이브 🚗","맛집 🥘", "산책 🌲", "뷰맛집 🌇",]
    
    //var onCategorySelected: ((String) -> Void)? // 선택된 카테고리를 전달할 클로저
    private var selectedCategory: String? // 현재 선택된 카테고리를 저장하는 변수
    
    var selectedCategories: [String] = []   // 현재 선택된 카테고리를 저장하는 배열
    var onCategoriesSelected: (([String]) -> Void)?  // 선택된 카테고리를 전달할 클로저
    var selectedIndexPaths: [IndexPath] = []
    
    private var selectedIndexPath: IndexPath? // 선택된 셀의 인덱스를 저장하는 변수
    
    // MARK: - UI Components
    let basicView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "여행로그의 카테고리를 선택해주세요 😀 (최대 3개)"
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize  // 셀 크기를 자동으로 조정
        // layout.itemSize = CGSize(width: 100, height: 30)
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CategoryCell.self .self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let applyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("선택 완료", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 10
        button.isEnabled = true
        return button
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureConstraints()
        configureCollectionView()
        
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()] // 시트 높이 설정
            sheet.prefersGrabberVisible = true    // 손잡이 표시
        }
    }
    
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(basicView)
        basicView.addSubview(titleLabel)
        basicView.addSubview(categoryCollectionView)
        basicView.addSubview(applyButton)
        
        basicView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            basicView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basicView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            basicView.topAnchor.constraint(equalTo: view.topAnchor), // 상단 제약 추가
            basicView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: basicView.topAnchor, constant: 30),
            
            categoryCollectionView.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 10),
            categoryCollectionView.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -10),
            categoryCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 250),
            //categoryCollectionView.bottomAnchor.constraint(equalTo: applyButton.topAnchor, constant: -10), // applyButton과의 제약 추가
            
            applyButton.leadingAnchor.constraint(equalTo: basicView.leadingAnchor, constant: 20),
            applyButton.trailingAnchor.constraint(equalTo: basicView.trailingAnchor, constant: -20),
            applyButton.bottomAnchor.constraint(equalTo: basicView.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            applyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    // MARK: - Functions
    func configureCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
    }
    
    
    // MARK: - Actions
    @objc private func applyButtonTapped() {
        onCategoriesSelected?(selectedCategories) // 선택된 카테고리 배열 전달
        dismiss(animated: true, completion: nil)
    }
}

extension CategorySheetViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
//            return UICollectionViewCell()
//        }
//        
//        let category = categories[indexPath.item]
//        cell.configure(with: category)
//        
//        // 선택된 카테고리에 따라 셀 배경색 변경
//        if indexPath == selectedIndexPath {
//            cell.basicView.backgroundColor = .black
//            cell.categoryLabel.textColor = .white
//        } else {
//            cell.basicView.backgroundColor = .secondarySystemBackground
//            cell.categoryLabel.textColor = .label
//        }
//        
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
                return UICollectionViewCell()
            }
            
            let category = categories[indexPath.item]
            cell.configure(with: category)
            
            // 선택된 카테고리에 따라 셀 배경색과 텍스트 색상 변경
            if selectedCategories.contains(category) {
                cell.basicView.backgroundColor = .black
                cell.categoryLabel.textColor = .white
            } else {
                cell.basicView.backgroundColor = .secondarySystemBackground
                cell.categoryLabel.textColor = .label
            }
            
            return cell
        }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let previousSelectedIndexPath = selectedIndexPath
//        selectedIndexPath = indexPath // 새로 선택된 인덱스로 업데이트
//        
//        let selectedItem = categories[indexPath.item]
//        self.selectedCategory = selectedItem
//        
//        // 이전에 선택된 셀이 있으면 해당 셀을 리로드하여 원래 상태로 복구
//        if let previousSelectedIndexPath = previousSelectedIndexPath {
//            collectionView.reloadItems(at: [previousSelectedIndexPath])
//        }
//        
//        // 현재 선택된 셀 리로드하여 선택 상태로 표시
//        collectionView.reloadItems(at: [indexPath])
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let selectedItem = categories[indexPath.item]
         
         if selectedCategories.contains(selectedItem) {
             // 이미 선택된 항목이라면 선택 해제
             selectedCategories.removeAll { $0 == selectedItem }
             selectedIndexPaths.removeAll { $0 == indexPath }
         } else {
             // 새로운 항목 선택 (최대 3개까지 선택 가능)
             if selectedCategories.count < 3 {
                 selectedCategories.append(selectedItem)
                 selectedIndexPaths.append(indexPath)
             } else {
                 // 최대 개수에 도달한 경우, 추가 선택을 무시
                 return
             }
         }
         
         // 선택 상태에 따라 셀을 업데이트
         collectionView.reloadItems(at: [indexPath])
     }
    
}

//extension CategorySheetViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        // 화면 너비를 기준으로 셀 너비를 설정
//        let width = (collectionView.frame.width - 40) / 3 // 가로 셀 개수에 맞게 조정
//        return CGSize(width: width, height: 50) // 셀 높이를 고정하거나 필요에 맞게 조정
//    }
//}
