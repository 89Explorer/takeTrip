//
//  SearchResultsViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/25/24.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    // MARK: - Variables
    /// 결과를 받아오는 변수 배열
    var spotResults: [String] = []

    // MARK: - UI Components
    let spotTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    
    // MARK: - Initializations
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureConstraints()
        configureTableView()
    }
    
    // MARK: - Layouts
    private func configureConstraints() {
        view.addSubview(spotTableView)
        
        let spotTableViewConstraints = [
            spotTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spotTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spotTableView.topAnchor.constraint(equalTo: view.topAnchor),
            spotTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(spotTableViewConstraints)
    }
    
    // MARK: - Functions
    func configureTableView() {
        spotTableView.delegate = self
        spotTableView.dataSource = self
        spotTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updateTableView(with results: [String]) {
        self.spotResults = results
        spotTableView.reloadData()
    }
}


extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spotResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = spotResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 셀 선택 시 동작할 코드를 여기에 작성
        print("선택된 항목: \(spotResults[indexPath.row])")
    }
}
