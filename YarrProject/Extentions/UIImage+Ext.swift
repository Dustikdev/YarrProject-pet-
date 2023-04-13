import UIKit

extension UIImage {
    func toData() -> Data? {
        return jpegData(compressionQuality: 1.0)
    }
}
