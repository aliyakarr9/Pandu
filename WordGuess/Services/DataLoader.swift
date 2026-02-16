import Foundation

enum DataLoaderError: Error, LocalizedError {
    case fileNotFound(String)
    case loadFailed(String, Error)
    case parsingFailed(String, Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "'\(name)' dosyası bulunamadı."
        case .loadFailed(let name, let error):
            return "'\(name)' yüklenemedi: \(error.localizedDescription)"
        case .parsingFailed(let name, let error):
            return "'\(name)' ayrıştırılamadı: \(error.localizedDescription)"
        }
    }
}

class DataLoader {
    static let shared = DataLoader()

    private init() {}

    /// Güvenli yükleme — başarısız olursa boş dizi döner, crash yapmaz.
    func loadCards(_ filename: String) -> [WordCard] {
        switch loadSafe(filename) as Result<[WordCard], DataLoaderError> {
        case .success(let cards):
            return cards
        case .failure(let error):
            print("⚠️ DataLoader: \(error.localizedDescription)")
            return []
        }
    }
    
    /// Generic güvenli yükleme — Result tipi döner.
    func loadSafe<T: Decodable>(_ filename: String) -> Result<T, DataLoaderError> {
        let file = filename.hasSuffix(".json") ? filename : "\(filename).json"
        
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            return .failure(.fileNotFound(file))
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            return .failure(.loadFailed(file, error))
        }

        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return .success(result)
        } catch {
            return .failure(.parsingFailed(file, error))
        }
    }
}
