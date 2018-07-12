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
    var operations: [Any]
    var extensions: [String]?
    var signatures: [String]
    var userName: String = ""
    
    
    // MARK: - Class Initialization
    public init(withOperations operations: [Any], andExtensions extensions: [String]? = nil) {
        self.ref_block_num          =   headBlockNumber
        self.ref_block_prefix       =   headBlockID
        self.expiration             =   time
        self.operations             =   [operations]
        self.extensions             =   extensions
        self.signatures             =   [String]()
    }
    
    
    // MARK: - Custom Functions
    public mutating func setUserName(_ name: String) {
        self.userName               =   name
    }

    /// Service function to remove `operation code` from transaction
    private mutating func deleteOperationCode() {
        for (i, operation) in self.operations.enumerated() {
            if var operations = operation as? [Any] {
                operations.remove(at: 1)
                self.operations[i] = operations
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
    public mutating func serialize(byOperationType operationType: OperationAPIType) -> ErrorAPI? {
        /// Create `serializedBuffer` with `chainID`
        var serializedBuffer: [Byte] = chainID.hexBytes
        Logger.log(message: "\nserializedBuffer + chainID:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        // Add to buffer `ref_block_num` as `UInt16`
        let ref_block_num: UInt16 = self.ref_block_num
        serializedBuffer += ref_block_num.bytesReverse
        Logger.log(message: "\nserializedBuffer + ref_block_num:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        // Add to buffer `ref_block_prefix` as `UInt32`
        let ref_block_prefix: UInt32 = self.ref_block_prefix
        serializedBuffer += ref_block_prefix.bytesReverse
        Logger.log(message: "\nserializedBuffer + ref_block_prefix:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        // Add to buffer `expiration` as `UInt32`
        let expirationDate: UInt32 = UInt32(self.expiration.convert(toDateFormat: .expirationDateType).timeIntervalSince1970)
        serializedBuffer += expirationDate.bytesReverse
        Logger.log(message: "\nserializedBuffer + expiration:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        // Operations: add to buffer `the actual number of operations`
        let operations = self.operations
        serializedBuffer += self.varint(int: operations.count)
        Logger.log(message: "\nserializedBuffer + operationsCount:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        // Operations
        for operation in operations {
            // Operation: add to buffer `operation type name`
            if let operationArray = operation as? [Any], let operationTypeID = operationArray[1] as? Int {
                // Operations: add to buffer `operation type ID`
                serializedBuffer += self.varint(int: operationTypeID)
                Logger.log(message: "\nserializedBuffer - operationTypeID:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
                
                let keyNames = OperationAPIType.getFieldNames(byTypeID: operationTypeID)
                
                // Operations: add to buffer `operation fields`
                if let fields = operationArray[2] as? [String: Any] {
                    for keyName in keyNames {
                        let fieldValue = fields[keyName]
                        
                        if let fieldString = fieldValue as? String {
                            // Length + Type
                            let fieldStringBytes = fieldString.bytes
                            serializedBuffer += self.varint(int: fieldStringBytes.count) + fieldStringBytes
                            Logger.log(message: "\nserializedBuffer - fieldString:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
                        }
                            
                        else if let fieldInt = fieldValue as? Int64 {
                            // Value
                            serializedBuffer += UInt16(fieldInt).bytesReverse
                            Logger.log(message: "\nserializedBuffer - fieldInt:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
                        }
                    }
                }
            }
        }
        
        // Extensions: add to buffer `the actual number of operations`
        let extensions = self.extensions ?? [String]()
        serializedBuffer += self.varint(int: extensions.count)
        Logger.log(message: "\nserializedBuffer + extensionsCount:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        // Add SHA256
        let messageSHA256: [Byte] = serializedBuffer.sha256()
        Logger.log(message: "\nmessageSHA256:\n\t\(messageSHA256.toHexString())\n", event: .debug)
        
        // ECC signing
        let errorAPI = signingECC(messageSHA256: messageSHA256)
        Logger.log(message: "\nerrorAPI:\n\t\(errorAPI?.localizedDescription ?? "nil")\n", event: .debug)
        
        return errorAPI
    }
    
    /**
     ECC signing serialized buffer of transaction.
     
     - Parameter method: The name of used API method with needed parameters.
     - Returns: Return transaction signature.
     
     */
    private mutating func signingECC(messageSHA256: [Byte]) -> ErrorAPI? {
        if let privateKeyString = KeychainManager.loadPrivateKey(forUserName: self.userName) {
            let privateKeyData: [Byte] = Base58().base58Decode(data: privateKeyString)
            
            Logger.log(message: "\nsigningECC - privateKey:\n\t\(privateKeyString)\n", event: .debug)
            
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
