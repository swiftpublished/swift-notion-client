#if os(Linux)
import Glibc

let system_glob = Glibc.glob
#else
import Darwin

let system_glob = Darwin.glob
#endif

import Foundation

extension JSONDecoder {
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .formatted(.iso8601Notion)

        return decoder
    }
}
