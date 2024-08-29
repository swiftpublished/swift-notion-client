#if os(Linux)
import Glibc

let system_glob = Glibc.glob
#else
import Darwin

let system_glob = Darwin.glob
#endif

import Foundation

extension URLRequest {
    private enum Error: Swift.Error {
        case noSecret
    }

    static func standard(url: URL) throws -> Self {
        try Self(url: url)
            .addingDefaultHeaders()
    }

    private func addingDefaultHeaders() throws -> Self {
        guard let secret = ProcessInfo.processInfo.environment["SECRET"] else {
            throw Error.noSecret
        }

        var request = self

        request.addValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
        request.addValue("Bearer \(secret)", forHTTPHeaderField: "Authorization")

        return request
    }
}
