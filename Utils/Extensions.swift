import UIKit

extension UIImage {
    func toBase64() -> String? {
        // API'ye hızlı gitmesi için kaliteyi 0.5'e düşürüyoruz
        guard let imageData = self.jpegData(compressionQuality: 0.5) else { return nil }
        return "data:image/jpeg;base64," + imageData.base64EncodedString()
    }
}
