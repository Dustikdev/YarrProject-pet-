import UIKit

final class CommonCollectionViewCell: UICollectionViewCell {

    private let cellImage = UIImageView()
    private let cellLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellImage()
        setupCellLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(viewModel: ViewModel) {
        let image = viewModel.image ?? Images.AssetImages.defaultProjectIcon
        cellImage.image = image
        cellLabel.text = viewModel.text
        cellImage.layer.cornerRadius = 20
    }
    
    private func setupCellImage() {
        contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.clipsToBounds = true
        cellImage.contentMode = .scaleAspectFill
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupCellLabel() {
        contentView.addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.font = .systemFont(ofSize: 20, weight: .regular)
        cellLabel.textAlignment = .center
        cellLabel.numberOfLines = 1
        cellLabel.adjustsFontSizeToFitWidth = true
        cellLabel.minimumScaleFactor = 0.5
        NSLayoutConstraint.activate([
            cellLabel.topAnchor.constraint(equalTo: cellImage.bottomAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
