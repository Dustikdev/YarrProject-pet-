//
//  ProjectsListViewController.swift
//  YarrProject
//
//  Created by Никита Швец on 12.03.2023.
//

import UIKit

final class ProjectsListViewController: UIViewController {
    
    private let previewCollection = VerticalCollectionView()
    private let alertPresenter = AlertPresenter()
    private let context = CoreDataManager().persistentContainer.viewContext
    private var previewData = [PreviewData]()
    private var images = MockProvider().placeImages()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        previewCollection.delegate = self
        previewCollection.dataSource = self
        previewCollection.register(cellType: CommonCollectionViewCell.self)
    }
    
    @objc func didTapAddProjectButton() {
        alertPresenter.presentAlert(title: Strings.alertTitle, message: Strings.alertMessage, viewController: self) { [weak self] action, text in
            guard let self else { return }
            let newPreviewData = PreviewData(context: self.context)
            newPreviewData.path = text
            self.previewData.append(newPreviewData)
            self.previewCollection.reloadData()
        }
    }

    func presentProjectDetails() {
        let vc = ProjectDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
  
//MARK: - setupUI
    
    private func setupView() {
        setupNavigationBar()
        setupPreviewCollection()
        view.backgroundColor = .systemBackground
    }
    
    private func setupPreviewCollection() {
        view.addSubview(previewCollection)
        previewCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            previewCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Strings.projectListNavigationbarTitle
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAddProjectButton))
    }
}

//MARK: - collectionview delegates

extension ProjectsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
        presentProjectDetails()
    }
}
