import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension URLRequest {
    private enum Error: Swift.Error {
        case noSecret
    }

    static func standard(url: URL) throws -> Self {
        try Self(url: url)
            .addingDefaultHeaders()
    }

    func addingDefaultHeaders() throws -> Self {
        guard let secret = ProcessInfo.processInfo.environment["SECRET"] else {
            throw Error.noSecret
        }

        var request = self

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
        request.addValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")

        return request
    }

    func post() throws -> Self {
        var request = self

        request.httpMethod = "POST"

        return request
    }
}
