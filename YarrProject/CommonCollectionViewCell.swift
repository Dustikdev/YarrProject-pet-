//
//  PreviewCollectionViewCell.swift
//  YarrProject
//
//  Created by Никита Швец on 14.03.2023.
//

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
    
    func configure(image: UIImage) {
        cellImage.image = image
        cellLabel.text = "My label text"
        cellImage.layer.cornerRadius = 20
    }
    
    private func setupCellImage() {
        contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        cellImage.clipsToBounds = true
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
        cellLabel.numberOfLines = 0
        cellLabel.textColor = .black
        NSLayoutConstraint.activate([
            cellLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            cellLabel.topAnchor.constraint(equalTo: cellImage.bottomAnchor)
        ])
    }
}
