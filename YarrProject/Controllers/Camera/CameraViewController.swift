import UIKit
import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func cameraViewController(_ vc: CameraViewController, didSave viewModel: ViewModel)
    func сameraViewControllerDidClosed(_ vc: CameraViewController)
}

final class CameraViewController: UIViewController {
    
    weak var delegate: CameraViewControllerDelegate?
    private let closeButton = UIButton()
    private let makePhotoButton = UIButton()
    private let testImageView = UIImageView()
    private let photoOutput = AVCapturePhotoOutput()
    private let alertPresenter = AlertPresenter()
    private let previewPhoto = UIImageView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openCamera()
    }
    
    //MARK: - setupUI
    
    private func setupUI() {
        setupCloseButton()
        setupMakePhotoButton()
        setupPreviewPhoto()
    }
    
    private func setupCloseButton() {
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(Images.SystemImages.xmark, for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupMakePhotoButton() {
        view.addSubview(makePhotoButton)
        makePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        makePhotoButton.setImage(Images.AssetImages.cameraImage, for: .normal)
        makePhotoButton.addTarget(self, action: #selector(handleTakePhoto), for: .touchUpInside)
        NSLayoutConstraint.activate([
            makePhotoButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            makePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            makePhotoButton.heightAnchor.constraint(equalToConstant: 80),
            makePhotoButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setupPreviewPhoto() {
        view.addSubview(previewPhoto)
        previewPhoto.translatesAutoresizingMaskIntoConstraints = false
        previewPhoto.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            previewPhoto.topAnchor.constraint(equalTo: view.topAnchor),
            previewPhoto.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewPhoto.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewPhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    private func openCamera() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCaptureSession()
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { (granted) in
                if granted {
                    Logger.notification(Logger.Notifications.cameraAccessGranted)
                    DispatchQueue.main.async {
                        self.setupCaptureSession()
                    }
                } else {
                    Logger.error(Logger.Errors.cameraAccessNotGranted)
                    self.handleDismiss()
                }
            }
            
        case .denied:
            Logger.error(Logger.Errors.cameraAccessDenied)
            handleDismiss()
            
        case .restricted:
            Logger.error(Logger.Errors.cameraAccessRestricted)
            handleDismiss()
            
        default:
            Logger.error(Logger.Errors.cameraAccessDefaultMessage)
            handleDismiss()
        }
    }
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        
        if let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                if captureSession.canAddInput(input) {
                    captureSession.addInput(input)
                }
            } catch let error {
                Logger.error(Logger.Errors.errorWithCaptureSession, "\(error)")
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            let cameraLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            cameraLayer.frame = self.view.frame
            cameraLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(cameraLayer)
            DispatchQueue.global(qos: .userInteractive).async {
                captureSession.startRunning()
            }
            setupUI()
        }
    }
    
    private func makePhotoHandler(image: UIImage?) {
        previewPhoto.image = image
    }
    
    @objc private func handleDismiss() {
        DispatchQueue.main.async {
            self.delegate?.сameraViewControllerDidClosed(self)
        }
    }
    
    @objc private func handleTakePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        if let photoPreviewType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
            photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoPreviewType]
            photoOutput.capturePhoto(with: photoSettings, delegate: self)
        }
    }
    
    private func didSaveButtonTapped(model: ViewModel) {
        delegate?.cameraViewController(self, didSave: model)
        handleDismiss()
    }
}

//MARK: - AVCapturePhotoCaptureDelegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else { return }
        let image = UIImage(data: imageData)
        makePhotoHandler(image: image)
        self.alertPresenter.presentAlert(
            over: self,
            title: Strings.Alerts.alertTitleEdit,
            message: nil,
            actions: [
                .init(
                    title: Strings.Alerts.alertAddActionTitle,
                    style: .default,
                    handler: { [weak self] text in
                        guard let self else { return }
                        self.didSaveButtonTapped(model: ViewModel(image: image, text: text))
                    }
                ),
                .init(
                    title: Strings.Alerts.alertCancelActionTitle,
                    style: .destructive,
                    handler: { _ in
                        self.previewPhoto.removeFromSuperview()
                    }
                )
            ]
        )
    }
}
