import UIKit
import Foundation

struct DesignResult: Identifiable {
    let id = UUID()
    let originalImage: UIImage
    let generatedImage: UIImage
    let style: String
    let date: Date = Date()
}
