import Foundation

extension JSONDecoder {
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .formatted(.iso8601Notion)

        return decoder
    }
}
