//
//  UICollectionView+Ext.swift
//  YarrProject
//
//  Created by Никита Швец on 06.04.2023.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        let cellId = String(describing: cellType)
        self.register(T.self, forCellWithReuseIdentifier: cellId)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type,for indexPath: IndexPath) -> T {
        let cellId = String(describing: type)
        return self.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! T
    }
}
