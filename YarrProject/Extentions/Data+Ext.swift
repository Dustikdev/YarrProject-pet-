import UIKit

extension Data {
    func toImage() -> UIImage? {
        return UIImage(data: self)
    }
}
