import SwiftUI

@MainActor
class DesignViewModel: ObservableObject {
    @Published var originalImage: UIImage?
    @Published var generatedImage: UIImage?
    @Published var isProcessing = false
    @Published var statusMessage = "Ready"
    @Published var savedDesigns: [DesignResult] = []
    
    private let service = APIService()
    
    func generateDesign(style: String) {
        guard let original = originalImage else { return }
        
        isProcessing = true
        statusMessage = "Magic happening..."
        
        Task {
            do {
                let resultImage = try await service.generateMockDesign()
                
                self.generatedImage = resultImage
                self.statusMessage = "Done!"
                self.isProcessing = false
                
                let newDesign = DesignResult(originalImage: original, generatedImage: resultImage, style: style)
                self.savedDesigns.insert(newDesign, at: 0)
                
            } catch {
                print("Error: \(error)")
                self.statusMessage = "Error"
                self.isProcessing = false
            }
        }
    }
}
