import Foundation

// API'ye gönderilecek istek gövdesi
struct PredictionRequest: Encodable {
    let version: String
    let input: InputParams
}

struct InputParams: Encodable {
    let image: String // Base64 string
    let prompt: String
    let structure: String = "canny" // Yapıyı koruması için
}

// API'den gelen cevap
struct PredictionResponse: Decodable {
    let id: String
    let status: String // "starting", "processing", "succeeded", "failed"
    let output: [String]? // Tamamlandığında resim URL'i burada olacak
}
