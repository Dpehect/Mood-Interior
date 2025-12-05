import Foundation
import UIKit

class APIService {
    func generateMockDesign() async throws -> UIImage {
        try await Task.sleep(nanoseconds: 3 * 1_000_000_000)
        
        if let mockImage = UIImage(named: "sample_result") {
            return mockImage
        } else {
            return UIImage(systemName: "photo.artframe") ?? UIImage()
        }
    }
}
