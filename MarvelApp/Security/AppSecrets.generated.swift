// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import CryptoKit
import Foundation

struct AppSecrets {
    static let marvelApiKey = ""
    private static let privateKey = ""
    static let timestamp = Date().hashValue.description
    static var hash: String = {
        let toHash = timestamp + privateKey + marvelApiKey
        guard let binaryToHash = toHash.data(using: .utf8) else {
            return "INVALID_HASH"
        }
        return Insecure.MD5.hash(data: binaryToHash).map {
            String(format: "%02hhx", $0)
        }.joined()
    }()
}
