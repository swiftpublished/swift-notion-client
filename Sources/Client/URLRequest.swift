import Foundation

extension URLRequest {
    static func standard(url: URL) -> Self {
        Self(url: url)
            .addingDefaultHeaders()
    }

    private func addingDefaultHeaders() -> Self {
        var request = self

        request.addValue("2022-06-28", forHTTPHeaderField: "Notion-Version")
        request.addValue(
            "Bearer secret_Scnu6Te2fKACKHGbwb1SvEIw4g7XJ14juzRynTwmUsD",
            forHTTPHeaderField: "Authorization"
        )

        return request
    }
}
