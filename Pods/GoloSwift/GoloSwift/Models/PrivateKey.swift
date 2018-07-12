/// Steem PrivateKey implementation.
/// - Author: Johan Nordberg <johan@steemit.com>

import Foundation

public enum PrivateKeyType: Int {
    case memo = 0
    case owner
    case active
    case posting
}

/// A Steem private key.
public struct PrivateKey: Equatable {
    private let secret: Data

    /// For testing, wether to use a counter or random value for ndata when signing.
    internal static var determenisticSignatures: Bool = false

    /// Create a new private key instance from a byte buffer.
    /// - Parameter data: The 33-byte private key where the first byte is the network id (0x80).
    public init?(_ data: Data) {
        guard data.first == 0x80 && data.count == 33 else {
            return nil
        }
        
        let secret = data.suffix(from: 1)
        
        guard Secp256k1Context.shared.verify(secretKey: secret) else {
            return nil
        }
        
        self.secret = secret
    }

    /// Create a new private key instance from a WIF-encoded string.
    /// - Parameter wif: The base58check-encoded string.
    public init?(_ wif: String) {
        guard let data = Data(base58CheckEncoded: wif) else {
            return nil
        }
        
        self.init(data)
    }


    /// Derive the public key for this private key.
    /// - Parameter prefix: Address prefix to use when creating key, defaults to main net (STM).
    public func createPublic(prefix: PublicKey.AddressPrefix = .mainNet) -> PublicKey {
        let result = try! Secp256k1Context.shared.createPublic(fromSecret: self.secret)
        
        return PublicKey(key: result, prefix: prefix)!
    }

    /// The 33-byte private key where the first byte is the network id (0x80).
    public var data: Data {
        var data = self.secret
        data.insert(0x80, at: data.startIndex)
       
        return data
    }

    /// WIF-encoded string representation of private key.
    public var wif: String {
        return self.data.base58CheckEncodedString()!
    }
}

extension PrivateKey: LosslessStringConvertible {
    public var description: String {
        return self.wif
    }
}
