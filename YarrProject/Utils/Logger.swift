import UIKit

struct Logger {
    
    struct Errors {
        static let cameraAccessNotGranted = "The user has not granted to access the camera"
        static let cameraAccessRestricted = "The user can't give camera access due to some restriction."
        static let cameraAccessDenied = "The user has denied previously to access the camera."
        static let cameraAccessDefaultMessage = "Something has wrong due to we can't access the camera."
        static let errorWithCaptureSession = "Failed to set input device with error: "
    }

    struct Notifications {
        static let cameraAccessGranted = "The user has granted to access the camera."
    }
    
    static func error(_ message: String? = nil, _ error: String? = nil, file: String = #file, line: Int = #line) {
        let message = message ?? ""
        if error == nil {
            print("📕 [ERROR][START]: \(message) \n📕 [FILE]: \(file.components(separatedBy: "/").last ?? "") \n📕 [LINE]: \(line) \n📕 [END]\n")
        } else {
            print("📕 [ERROR][START]: \(message) \n \(String(describing: error))\n📕 [FILE]: \(file.components(separatedBy: "/").last ?? "") \n📕 [LINE]: \(line) \n📕 [END]\n")
        }
    }
    
    static func notification(_ notification: String? = nil, file: String = #file, line: Int = #line) {
        let notification = notification ?? ""
        print("📘 [NOTIFICATION][START]: \(notification) \n📘 [FILE]: \(file.components(separatedBy: "/").last ?? "") \n📘 [LINE]: \(line) \n📘 [END]\n")
    }
}
