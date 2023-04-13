import UIKit
import CoreData

final class ProjectDetailsViewController: UIViewController {
    
    var selectedProject: ProjectsListData? {
        didSet {
            if let argument = selectedProject?.explanation {
                let predicate = NSPredicate(format: Predicates.forProjectDetails, argument)
                projectDetailsData = modelManager.getProjectDetails(with: predicate)
            }
        }
    }
    private var selectedData: ProjectDetailsData?
    private var projectDetailsData = [ProjectDetailsData]()
    private let projectDetailsCollection = VerticalCollectionView()
    private let alertPresenter = AlertPresenter()
    private let modelManager = BusinessModelManager.shared
    private let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        projectDetailsCollection.delegate = self
        projectDetailsCollection.dataSource = self
        projectDetailsCollection.register(cellType: CommonCollectionViewCell.self)
    }
    
    @objc private func didTapAddView() {
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
        let tempProjectDetailsData = self.modelManager.projectDetailsData()
        tempProjectDetailsData.explanation = text
        tempProjectDetailsData.detailsToList = self.selectedProject
        modelManager.save()
        projectDetailsData.append(tempProjectDetailsData)
        projectDetailsCollection.reloadData()
    }
    
    private func saveImage(image: UIImage?) {
        if let image {
            selectedData?.imageData = image.toData()
            modelManager.save()
            projectDetailsCollection.reloadData()
        }
    }
    
    private func didTapDeleteProject(with data: ProjectDetailsData) {
        self.projectDetailsData.removeAll { $0.id == data.id }
        self.modelManager.delete(data: data)
        self.modelManager.save()
        self.projectDetailsCollection.reloadData()
    }
    
    @objc private func didMakePhotoButton() {
        presentCameraViewController()
    }
    
    private func presentCameraViewController() {
        let vc = CameraViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    private func didTapEditAlert(text: String?, data: ProjectDetailsData) {
        data.explanation = text
        self.modelManager.save()
        self.projectDetailsCollection.reloadData()
    }
    
//MARK: - setupUI
    
    private func setupView() {
        setupNavigationBar()
        setupPreviewCollection()
        view.backgroundColor = .systemBackground
    }
    
    private func setupPreviewCollection() {
        view.addSubview(projectDetailsCollection)
        projectDetailsCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            projectDetailsCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            projectDetailsCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            projectDetailsCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            projectDetailsCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.title = selectedProject?.explanation
        navigationController?.navigationBar.backgroundColor = .systemBackground
        let plus = UIBarButtonItem(image: Images.SystemImages.plus, style: .plain, target: self, action: #selector(didTapAddView))
        let photo = UIBarButtonItem(image: Images.SystemImages.photo, style: .plain, target: self, action: #selector(didMakePhotoButton))
        navigationItem.rightBarButtonItems = [plus, photo]
    }

//MARK: - menuConfiguration
    
    private func configureContextMenu(data: ProjectDetailsData) -> UIContextMenuConfiguration {
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

extension ProjectDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return projectDetailsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: CommonCollectionViewCell.self, for: indexPath)
        let projectData = projectDetailsData[safe: indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else {
            return nil
        }
        if let detailsData = projectDetailsData[safe: indexPath.row] {
            return configureContextMenu(data: detailsData)
        }
        return nil
    }
}

extension ProjectDetailsViewController: UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    
    private func setPicture(for data: ProjectDetailsData) {
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
//MARK: - CameraViewControllerDelegate

extension ProjectDetailsViewController: CameraViewControllerDelegate {
    
    func сameraViewControllerDidClosed(_ vc: CameraViewController) {
        vc.dismiss(animated: true)
    }
    
    func cameraViewController(_ vc: CameraViewController, didSave viewModel: ViewModel) {
        let tempProjectDetailsData = modelManager.projectDetailsData()
        tempProjectDetailsData.explanation = viewModel.text
        if let convertedImage = viewModel.image {
            tempProjectDetailsData.imageData = convertedImage.toData()
        }
        tempProjectDetailsData.detailsToList = self.selectedProject
        self.modelManager.save()
        self.projectDetailsData.append(tempProjectDetailsData)
        self.projectDetailsCollection.reloadData()
    }
}
