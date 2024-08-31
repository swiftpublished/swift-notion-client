import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import NotionParsing

extension URLRequest {
    static func database(url: URL, status: Page.Properties.Status.Value) throws -> Self {
        try Self(url: url)
            .post()
            .addingDefaultHeaders()
            .addingFilter(for: status)
    }

    private func addingFilter(for status: Page.Properties.Status.Value) throws -> Self {
        var request = self

        var body: [String: Any] = [:]
        var statusProperty: [String: Any] = ["property": "Status"]
        let statusValue: [String: String] = ["equals": status.rawValue]
        statusProperty["status"] = statusValue
        body["filter"] = statusProperty

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        return request
    }
}
