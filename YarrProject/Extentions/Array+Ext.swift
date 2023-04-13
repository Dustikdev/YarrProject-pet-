import Foundation

extension Array {
    public subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
