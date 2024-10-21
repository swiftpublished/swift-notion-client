import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

import NotionParsing

public func queryDatabasePages(
    by id: String,
    and status: Page.Properties.Status.Value
) async throws -> [Page] {
    let request: URLRequest = try .database(url: .database(by: id), status: status)

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder: JSONDecoder = .standard
        let database = try decoder.decode(Database.self, from: data)
        return database.pages
    } catch {
        throw error
    }
}

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

private func fetchContent(
    by id: String, 
    level: Int? = nil,
    startCursor: String? = nil
) async throws -> Content {
    let request: URLRequest = try .standard(url: .blocks(by: id, and: startCursor))

    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder: JSONDecoder = .standard
        var content = try decoder.decode(Content.self, from: data)

        /// Fetch details about Linked Page
        for (index, block) in content.blocks.enumerated() {
            if case .linkedPage(var linkedPage) = block.type {
                let page = try await fetchPage(by: linkedPage.pageId)
                linkedPage.title = page.properties.title

                let linkedBlock = Block(
                    id: block.id,
                    hasChildren: block.hasChildren,
                    type: .linkedPage(linkedPage),
                    level: block.level,
                    children: block.children
                )
                content.blocks[index] = linkedBlock
            }
        }

        if let level = level {
            for (index, var block) in content.blocks.enumerated() {
                block.level = level
                content.blocks[index] = block
            }
        }

        if content.hasMore, let nextCursor = content.nextCursor {
            content.blocks += try await fetchContent(by: id, startCursor: nextCursor).blocks
        }

        for (index, var block) in content.blocks.enumerated() {
            if block.hasChildren {
                let level = (block.level ?? 0) + 1
                block.children = try await fetchContent(by: block.id, level: level).blocks
                content.blocks[index] = block
            }
        }

        return content
    } catch {
        throw error
    }
}
