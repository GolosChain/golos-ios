//
//  Transaction.swift
//  GoloSwift
//
//  Created by msm72 on 22.04.2018.
//  Copyright © 2018 Golos.io. All rights reserved.
//
//  https://github.com/Chainers/Ditch/blob/be57f990860bd8cc0d047d0b0bcd99c526a15f94/Sources/Ditch.Golos/Models/Other/Transaction.cs

import Foundation
import secp256k1
import CryptoSwift

public typealias Byte = UInt8
public typealias TransactionOperationType = [String: [String: Any]]

public struct Transaction {
    // MARK: - Properties
    let ref_block_num: UInt16
    let ref_block_prefix: UInt32
    let expiration: String                              // '2016-08-09T10:06:15'
    var operations: [Encodable]
    var extensions: [String]?
    var signatures: [String]
    var userName: String = ""
    var serializedBuffer: [Byte]
    
    
    // MARK: - Class Initialization
    public init(withOperations operations: [Encodable], andExtensions extensions: [String]? = nil) {
        self.ref_block_num          =   headBlockNumber
        self.ref_block_prefix       =   headBlockID
        self.expiration             =   time
        self.operations             =   operations
        self.extensions             =   extensions
        self.signatures             =   [String]()
        self.serializedBuffer       =   [Byte]()
    }
    
    
    // MARK: - Custom Functions
    public mutating func setUser(name: String) {
        self.userName               =   name
    }

    /// Service function to remove `operation code` from transaction
    private mutating func deleteOperationCode() {
        for (i, operation) in self.operations.enumerated() {
            if var operations = operation as? [Encodable] {
                operations.remove(at: 1)
                self.operations[i] = operations as! Encodable
            }
        }
    }
    
    /// Service function to add signature in transaction
    private mutating func add(signature: String) {
        self.signatures.append(signature)
    }
    
    /**
     Serialize transaction.
     
     - Parameter operationType: The type of operation.
     - Returns: Error or nil.
     
     */
    public mutating func serialize(byOperationAPIType operationAPIType: OperationAPIType) -> ErrorAPI? {
        /// Create `serializedBuffer` with `chainID`
        self.serializedBuffer = chainID.hexBytes
        Logger.log(message: "\nserializedBuffer + chainID:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)
        
        // Add to buffer `ref_block_num` as `UInt16`
        self.serializedBuffer += self.ref_block_num.bytesReverse
        Logger.log(message: "\nserializedBuffer + ref_block_num:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)

        // Add to buffer `ref_block_prefix` as `UInt32`
        self.serializedBuffer += self.ref_block_prefix.bytesReverse
        Logger.log(message: "\nserializedBuffer + ref_block_prefix:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)

        // Add to buffer `expiration` as `UInt32`
        let expirationDate: UInt32 = UInt32(self.expiration.convert(toDateFormat: .expirationDateType).timeIntervalSince1970)
        self.serializedBuffer += expirationDate.bytesReverse
        Logger.log(message: "\nserializedBuffer + expiration:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)
        
        // Operations: serialize
        // https://golos.io/ru--golos/@steepshot/praktika-razrabotki-na-c-dlya-blokcheinov-na-graphene
        self.serialize(array: self.operations)
        
        // Extensions: add to buffer `the actual number of operations`
        let extensions = self.extensions ?? [String]()
        self.serializedBuffer += self.varint(int: extensions.count)
        Logger.log(message: "\nserializedBuffer + extensionsCount:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)
        
        // Add SHA256
        let messageSHA256: [Byte] = self.serializedBuffer.sha256()
        Logger.log(message: "\nmessageSHA256:\n\t\(messageSHA256.toHexString())\n", event: .debug)
        
        // ECC signing
        let errorAPI = signingECC(messageSHA256: messageSHA256)
        Logger.log(message: "\nerrorAPI:\n\t\(errorAPI?.localizedDescription ?? "nil")\n", event: .debug)

        return errorAPI
    }
    
    /// Serialize Operations
    private mutating func serialize(array: [Any]) {
        // Add to buffer `the actual number of operations`
        self.serializedBuffer += self.varint(int: self.operations.count)
        Logger.log(message: "\nserializedBuffer + operationsCount:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        for operation in operations {
            // Get OperationAPIType properties sequence
            let operationTypeID                 =   (operation as! RequestParameterAPIPropertiesSupport).code!
            let operationTypeProperties         =   (operation as! RequestParameterAPIPropertiesSupport).getProperties()
            let operationTypePropertiesNames    =   (operation as! RequestParameterAPIPropertiesSupport).getPropertiesNames()

            // Operations: add to buffer `operation type ID`
            self.serializedBuffer   +=  self.varint(int: operationTypeID)
            Logger.log(message: "\nserializedBuffer - operationTypeID:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)

            // Operations: add to buffer `operation fields`
            for operationTypePropertyName in operationTypePropertiesNames {
                let operationTypePropertyValue  =   operationTypeProperties[operationTypePropertyName]
                
                // Operations: serialize string
                if let value = operationTypePropertyValue as? String {
                    self.serialize(string: value)
                }
                
                // Operations: serialize Int64
                else if let value = operationTypePropertyValue as? Int64 {
                    self.serialize(int64: value)
                }
                
                Logger.log(message: "\nserializedBuffer - \(operationTypePropertyName):\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)
            }
        }
    }
    
    private mutating func serialize(string: String) {
        // Length + Type
        let fieldStringBytes    =   string.bytes
        self.serializedBuffer   +=  self.varint(int: fieldStringBytes.count) + fieldStringBytes
    }
    
    private mutating func serialize(int64: Int64) {
        self.serializedBuffer   +=  UInt16(int64).bytesReverse
    }


    
    /**
     ECC signing serialized buffer of transaction.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return transaction signature.
     
     */
    private mutating func signingECC(messageSHA256: [Byte]) -> ErrorAPI? {
        if let privateKeyString = KeychainManager.loadPrivateKey(forUserName: self.userName) {
            let privateKeyData: [Byte] =  GSBase58().base58Decode(data: privateKeyString)

            Logger.log(message: "\nsigningECC - privateKey:\n\t\(privateKeyString)\n", event: .debug)
            Logger.log(message: "\nsigningECC - privateKeyData:\n\t\(privateKeyData.toHexString())\n", event: .debug)

            var index: Int = 0
            var extra: [Byte]?
            var loopCounter: Byte = 0
            var recoveryID: Int32 = 0
            var isRecoverable: Bool = false
            var signature = secp256k1_ecdsa_recoverable_signature()             // sig
            let ctx: OpaquePointer = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN | SECP256K1_CONTEXT_VERIFY))
            
            while (!(isRecoverable && isCanonical(signature: signature))) {
                if (loopCounter == 0xff) {
                    index += 1
                    loopCounter = 0
                }
                
                if (loopCounter > 0) {
                    extra = [Byte].add(randomElementsCount: 32)             // new bytes[32]
                }
                
                loopCounter += 1
                isRecoverable = (secp256k1_ecdsa_sign_recoverable(ctx, &signature, messageSHA256, privateKeyData, nil, extra) as NSNumber).boolValue
                Logger.log(message: "\nsigningECC - extra:\n\t\(String(describing: extra?.toHexString()))\n", event: .debug)
                Logger.log(message: "\nsigningECC - sig.data:\n\t\(signature.data))\n", event: .debug)
            }
            
            var output65: [Byte] = [Byte].init(repeating: 0, count: 65)     // add(randomElementsCount: 65)         // new bytes[65]
            secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, &output65[1], &recoveryID, &signature)
            
            // 4 - compressed | 27 - compact
            Logger.log(message: "\nsigningECC - output65-1:\n\t\(output65.toHexString())\n", event: .debug)
            output65[0] = Byte(recoveryID + 4 + 27)                             // (byte)(recoveryId + 4 + 27)
            Logger.log(message: "\nsigningECC - output65-2:\n\t\(output65.toHexString())\n", event: .debug)
            
            self.add(signature: output65.toHexString())
            Logger.log(message: "\ntx - ready:\n\t\(self)\n", event: .debug)
        }
        
        return nil
    }
    
    /// Service function from Python
    private func isCanonical(signature: secp256k1_ecdsa_recoverable_signature) -> Bool {
        return  !((signature.data.31 & 0x80) > 0)   &&
                !(signature.data.31 == 0)           &&
                !((signature.data.30 & 0x80) > 0)   &&
                !((signature.data.63 & 0x80) > 0)   &&
                !(signature.data.63 == 0)           &&
                !((signature.data.62 & 0x80) > 0)
    }
}


// MARK: - Transaction extension
extension Transaction {
    /// Convert Int -> [Byte]
    private func varint(int: Int) -> [Byte] {
        var bytes = [Byte]()
        var n = int
        var hexString = String(format:"%02x", arguments: [n])

        while Int(hexString, radix: 16)! >= 0x80 {
            bytes += Byte((n & 0x7f) | 0x80).data
            n = n >> 7
            hexString = String(format:"%02x", arguments: [n])
        }

        bytes += Int8(hexString, radix: 16)!.data

        return bytes
    }
}
