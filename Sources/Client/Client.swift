import Foundation
import NotionParsing

public func fetchPageContent(by id: String) async throws -> Page {
    var page = try await fetchPage(by: id)
    page.content = try await fetchContent(by: id)
    return page
}

private func fetchPage(by id: String) async throws -> Page {
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

private func fetchContent(by id: String, startCursor: String? = nil) async throws -> Content {
    let request: URLRequest = try .standard(url: .blocks(by: id, and: startCursor))

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder: JSONDecoder = .standard
        var content = try decoder.decode(Content.self, from: data)

        if content.hasMore, let nextCursor = content.nextCursor {
            content.blocks += try await fetchContent(by: id, startCursor: nextCursor).blocks
        }

        for (index, var block) in content.blocks.enumerated() {
            if block.hasChildren {
                block.children = try await fetchContent(by: block.id).blocks
                content.blocks[index] = block
            }
        }

        return content
    } catch {
        throw error
    }
}