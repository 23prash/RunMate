import Foundation
import os.log

final class QuoteProvider {
    enum QuoteType: String {
        case preRun = "pre_run"
        case postRun = "post_run"
    }
    let type: QuoteType
    init(type: QuoteType) {
        self.type = type
    }
    
    private lazy var quotes = (try? loadQuotes(for: type)) ?? []
    
    func getQuote() -> String {
        return quotes.randomElement() ?? ""
    }
    
    private func loadQuotes(for type: QuoteType) throws -> [String] {
        guard let infoPlistPath = Bundle.main.url(forResource: "Quotes", withExtension: "plist") else { return [] }
        let infoPlistData = try Data(contentsOf: infoPlistPath)
        if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any],
           let quotes = dict[type.rawValue] as? [String] {
            return quotes
        }
        return []
    }
}
