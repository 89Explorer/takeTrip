//
//  FullScreenImageViewController.swift
//  takeTrip
//
//  Created by 권정근 on 10/22/24.
//

import UIKit
import SDWebImage

class FullScreenImageViewController: UIViewController {
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Properties
    private var images: [String] = []
    private var currentIndex: Int = 0
    
    // MARK: - Initializer
    init(images: [String], currentIndex: Int) {
        self.images = images
        self.currentIndex = currentIndex
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        updateImage()
        
        // Add swipe gestures
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeLeft.direction = .left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    // MARK: - Setup
    private func setupViews() {
        view.backgroundColor = .black
        view.addSubview(imageView)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    // MARK: - Layouts
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    // MARK: - Actions
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            currentIndex = (currentIndex + 1) % images.count
        } else if gesture.direction == .right {
            currentIndex = (currentIndex - 1 + images.count) % images.count
        }
        updateImage()
    }
    
    // MARK: - Helper Methods
    private func updateImage() {
        let imageUrl = images[currentIndex]

        let securePosterURL = imageUrl.replacingOccurrences(of: "http://", with: "https://")
        
        let url = URL(string: securePosterURL)
        imageView.sd_setImage(with: url)
    }
}
