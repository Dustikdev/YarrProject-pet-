import UIKit

final class ProjectsListViewController: UIViewController {
    
    private let projectsListCollection = VerticalCollectionView()
    private let alertPresenter = AlertPresenter()
    private let modelManager = BusinessModelManager.shared
    private var projectsListData = [ProjectsListData]()
    private let imagePicker = UIImagePickerController()
    private var selectedData: ProjectsListData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        projectsListCollection.delegate = self
        projectsListCollection.dataSource = self
        projectsListCollection.register(cellType: CommonCollectionViewCell.self)
        projectsListData = modelManager.getProjectLists()
    }
    
    @objc private func didTapAddProject() {
        alertPresenter.presentAlert(
            over: self,
            title: Strings.Alerts.alertTitleProjectList,
            message: Strings.Alerts.alertMessage,
            actions: [
                .init(title: Strings.Alerts.alertAddActionTitle, style: .default, handler: { [weak self] text in
                    guard let self else { return }
                    self.saveText(text: text)
                }),
                .init(title: Strings.Alerts.alertCancelActionTitle, style: .destructive, handler: { _ in
                })
            ])
    }
    
    private func saveText(text: String?) {
        let tempProjectsListData = modelManager.projectListData()
        tempProjectsListData.explanation = text
        modelManager.save()
        projectsListData.append(tempProjectsListData)
        projectsListCollection.reloadData()
    }
    
    private func saveImage(image: UIImage?) {
        if let image {
            selectedData?.imageData = image.toData()
            modelManager.save()
            projectsListCollection.reloadData()
        }
    }
    
    private func didTapDeleteProject(with data: ProjectsListData) {
        projectsListData.removeAll { $0.id == data.id }
        modelManager.delete(data: data)
        modelManager.save()
        projectsListCollection.reloadData()
    }

    private func didTapEditAlert(text: String?, data: ProjectsListData) {
        data.explanation = text
        self.modelManager.save()
        self.projectsListCollection.reloadData()
    }
    
    private func presentProjectDetails(with projectData: ProjectsListData) {
        let vc = ProjectDetailsViewController()
        vc.selectedProject = projectData
        navigationController?.pushViewController(vc, animated: true)
    }
  
//MARK: - setupUI
    
    private func setupView() {
        setupNavigationBar()
        setupPreviewCollection()
        view.backgroundColor = .systemBackground
    }
    
    private func setupPreviewCollection() {
        view.addSubview(projectsListCollection)
        projectsListCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectsListCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectsListCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            projectsListCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            projectsListCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = Strings.NavigationBarTitles.projectListNavigationbarTitle
        navigationController?.navigationBar.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.SystemImages.plus, style: .plain, target: self, action: #selector(didTapAddProject))
    }
    
//MARK: - menuConfiguration
    
    private func configureContextMenu(data: ProjectsListData) -> UIContextMenuConfiguration {
            let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] (action) -> UIMenu? in
                guard let self else { return nil }
                let setupPhoto = UIAction(title: Strings.ContextMenuTitles.edit, image: Images.SystemImages.photo, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] (_) in
                    self?.setPicture(for: data)
                }
                let delete = UIAction(title: Strings.ContextMenuTitles.delete, image: Images.SystemImages.trash, identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { [weak self] (_) in
                    self?.didTapDeleteProject(with: data)
                }
                let editText = UIAction(title: Strings.ContextMenuTitles.rename, image: Images.SystemImages.pencil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] (_) in
                    guard let self else { return }
                    self.alertPresenter.presentAlert(
                        over: self,
                        title: Strings.Alerts.alertTitleEdit,
                        message: "",
                        actions: [
                            .init(title: Strings.Alerts.alertEditActionTitle, style: .default, handler: { [weak self] text in
                                self?.didTapEditAlert(text: text, data: data)
                            }),
                            .init(title: Strings.Alerts.alertCancelActionTitle, style: .destructive, handler: { _ in
                            })
                        ])
                }
                
                return UIMenu(title: Strings.ContextMenuTitles.menuName, image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [setupPhoto, editText, delete])
            }
            return context
        }
}

//MARK: - collectionview delegates

extension ProjectsListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectsListData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: CommonCollectionViewCell.self, for: indexPath)
        let projectData = projectsListData[safe: indexPath.row]
        let text = projectData?.explanation
        let image = projectData?.imageData?.toImage()
        cell.configure(viewModel: ViewModel(image: image, text: text))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CommonConstants.calcIndents(cellSize: view.frame.width , cells: 3), height: CommonConstants.calcIndents(cellSize: view.frame.width, cells: 3) + CommonConstants.labelIndent)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CommonConstants.minimumLineSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CommonConstants.minimumInteritemSpacingForSectionAt
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return CommonConstants.edgeInsetsForCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = projectsListData[safe: indexPath.row] {
            presentProjectDetails(with: data)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else {
            return nil
        }
        if let detailsData = projectsListData[safe: indexPath.row] {
            return configureContextMenu(data: detailsData)
        }
        return nil
    }
}

//MARK: - ImagePicker

extension ProjectsListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func setPicture(for data: ProjectsListData) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            selectedData = data
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        saveImage(image: selectedImage)
        dismiss(animated: true, completion: nil)
    }
}
