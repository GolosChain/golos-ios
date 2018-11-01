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
    var userNickName: String = ""
    var serializedBuffer: [Byte]
    
    
    // MARK: - Class Initialization
    public init(withOperations operations: [Encodable], andExtensions extensions: [String]? = nil, andGlobalProperties globalProperties: ResponseAPIDynamicGlobalProperty) {
        self.ref_block_num      =   UInt16(globalProperties.head_block_number & 0xFFFF)
        self.ref_block_prefix   =   globalProperties.head_block_id.convert(toIntFromStartByte: 12, toEndByte: 16)
        self.expiration         =   globalProperties.time.convert(toDateFormat: .expirationDateType).addingTimeInterval(60).convert(toStringFormat: .expirationDateType)
        self.operations         =   operations
        self.extensions         =   extensions
        self.signatures         =   [String]()
        self.serializedBuffer   =   [Byte]()
    }
    
    
    // MARK: - Custom Functions
    public mutating func setUser(nickName: String) {
        self.userNickName = nickName
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
        let chainID: String = (appBuildConfig == AppBuildConfig.development) ?  "5876894a41e6361bde2e73278f07340f2eb8b41c2facd29099de9deef6cdb679" :
                                                                                "782a3039b478c839e4cb0c941ff4eaeb7df40bdd68bd441afd444b9da763de12"

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
        guard let signature = SigningManager.signingECC(messageSHA256: messageSHA256, userNickName: self.userNickName) else {
            return ErrorAPI.signingECCKeychainPostingKeyFailure(message: "Signing Transaction Failure")
        }
        
        self.add(signature: signature)
        Logger.log(message: "\nsignature:\n\t\(signature)\n", event: .debug)
        
        return nil
    }
    
    
    /// Serialize Operations
    private mutating func serialize(array: [Any]) {
        // Add to buffer `the actual number of operations`
        self.serializedBuffer += self.varint(int: self.operations.count)
        Logger.log(message: "\nserializedBuffer + operationsCount:\n\t\(serializedBuffer.toHexString())\n", event: .debug)
        
        for operation in operations {
            // Get OperationAPIType properties sequence
            let operationTypeID                 =   (operation as! RequestParameterAPIOperationPropertiesSupport).code!
            let operationTypeProperties         =   (operation as! RequestParameterAPIOperationPropertiesSupport).getProperties()
            let operationTypePropertiesNames    =   (operation as! RequestParameterAPIOperationPropertiesSupport).getPropertiesNames()
            
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
                    
                    // Operations: serialize Array
                else if let values = operationTypePropertyValue as? [String] {
                    self.serializedBuffer += self.varint(int: values.count)
                    values.forEach({ self.serialize(string: $0) })
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
        self.serializedBuffer   +=  UInt16(bitPattern: Int16(int64)).bytesReverse
        Logger.log(message: "\nserializedBuffer:\n\t\(self.serializedBuffer.toHexString())\n", event: .debug)
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
