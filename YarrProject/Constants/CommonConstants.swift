import Foundation
import UIKit

struct CommonConstants {
    
    static let minimumLineSpacingForSectionAt: CGFloat = 10
    static let minimumInteritemSpacingForSectionAt: CGFloat = 10
    
    static let edgeInsetsForCell: UIEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
    
    static let labelIndent: CGFloat = 20
    
    static func calcIndents(cellSize: CGFloat, cells: Int) -> CGFloat {
        return CGFloat((Int(cellSize) - (21 + ((cells - 1) * 10))) / cells)
    }
}
