//
//  FeedViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/18/24.
//

import UIKit

class FeedViewController: UIViewController {
    
    
    // MARK: - UI Components
    let feedTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
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
        view.backgroundColor = .systemBlue
        
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
            feedTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: uploadButton.topAnchor, constant: -10),
            
            uploadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            uploadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            uploadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    
    // MARK: - Functions
    func setupNavigationBar() {
        navigationItem.title = "데이로그 작성"
        navigationController?.navigationBar.tintColor = .label
    }
    
    func setupTableView() {
        feedTableView.delegate = self
        feedTableView.dataSource = self
        feedTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "사진 추가 셀"
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "텍스트 추가 셀 "
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "공간 추가 셀"
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
}
