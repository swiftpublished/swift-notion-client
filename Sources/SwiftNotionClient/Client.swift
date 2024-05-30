import Foundation
import SwiftNotionParsing

public func fetchPage(by id: String) async throws -> Page {
    let request: URLRequest = try .standard(url: .page(by: id))

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder: JSONDecoder = .standard
        let page = try decoder.decode(Page.self, from: data)
        return page
    } catch {
        throw error
    }
}

public func fetchBlocks(by id: String, startCursor: String? = nil) async throws -> Content {
    let request: URLRequest = try .standard(url: .blocks(by: id, and: startCursor))

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder: JSONDecoder = .standard
        var content = try decoder.decode(Content.self, from: data)

        if content.hasMore, let nextCursor = content.nextCursor {
            content.results += try await fetchBlocks(by: id, startCursor: nextCursor).results
        }

        for (index, var result) in content.results.enumerated() {
            if result.hasChildren {
                result.children = try await fetchBlocks(by: result.id).results
                content.results[index] = result
            }
        }

        return content
    } catch {
        throw error
    }
}
