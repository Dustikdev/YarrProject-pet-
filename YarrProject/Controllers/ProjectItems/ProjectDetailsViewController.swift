//
//  ProjectDetailsViewController.swift
//  YarrProject
//
//  Created by Никита Швец on 24.03.2023.
//

import UIKit

final class ProjectDetailsViewController: UIViewController {
    
    private let projectCollection = VerticalCollectionView()
    private var images = MockProvider().placeImages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        projectCollection.delegate = self
        projectCollection.dataSource = self
        projectCollection.register(cellType: CommonCollectionViewCell.self)
    }
    
//MARK: - setupUI
    
    private func setupView() {
        setupNavigationBar()
        setupPreviewCollection()
        view.backgroundColor = .systemBackground
    }
    
    private func setupPreviewCollection() {
        view.addSubview(projectCollection)
        projectCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            projectCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            projectCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Strings.projectDetailsNavigationbarTitle
        navigationController?.navigationBar.backgroundColor = .white
    }
}

//MARK: - collectionview delegates

extension ProjectDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: CommonCollectionViewCell.self, for: indexPath)
        let image = images[indexPath.row]
        cell.configure(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((view.frame.width - 41)/3), height: ((view.frame.width - 41)/3) + 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CommonConstants.minimumLineSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CommonConstants.minimumInteritemSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: CommonConstants.UIEdgeInsetsTop, left: CommonConstants.UIEdgeInsetsLeft, bottom: CommonConstants.UIEdgeInsetsBottom, right: CommonConstants.UIEdgeInsetsRight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}
