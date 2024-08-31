import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URL {
    private enum Error: Swift.Error {
        case invalidURL
    }

    static func database(by id: String) throws -> Self {
        guard let url = Self(string: "https://api.notion.com/v1/databases/\(id)/query") else {
            throw Error.invalidURL
        }

        return url
    }

    static func page(by id: String) throws -> Self {
        guard let url = Self(string: "https://api.notion.com/v1/pages/\(id)") else {
            throw Error.invalidURL
        }

        return url
    }

    static func blocks(by id: String, and startCursor: String?) throws -> Self {
        guard var url = Self(string: "https://api.notion.com/v1/blocks/\(id)/children") else {
            throw Error.invalidURL
        }

        if let startCursor = startCursor {
            url.append(queryItems: [URLQueryItem(name: "start_cursor", value: startCursor)])
        }

        return url
    }
}
