//
//  RSA.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation

class RSA {
    
    struct KeyPair {
        let publicKey: SendableKey
        let privateKey: SendableKey
    }
    
    class SendableKey {
        let raw: SecKey
        
        init(_ raw: SecKey) {
            self.raw = raw
        }
        
        convenience init?(_ base64Encoded: String) {
            guard let cfdata = Data.init(base64Encoded: base64Encoded) else {
                return nil
            }
            
            let keyDict:[NSObject:NSObject] = [
                kSecAttrKeyType: kSecAttrKeyTypeRSA,
                kSecAttrKeyClass: kSecAttrKeyClassPublic,
                kSecAttrKeySizeInBits: NSNumber(value: 512),
                kSecReturnPersistentRef: true as NSObject
            ]
            
            guard let publicKey = SecKeyCreateWithData(cfdata as CFData, keyDict as CFDictionary, nil) else {
                return nil
            }
            
            self.init(publicKey)
        }
        
        func encodeBase64() -> String? {
            var error: Unmanaged<CFError>?
            guard let cfdata = SecKeyCopyExternalRepresentation(raw, &error) else {return nil}
            return (cfdata as Data).base64EncodedString()
        }
    }
    
    struct EncryptedData {
        let messageEncrypted: [UInt8]
        let blockSize: Int
        let messageEncryptedSize: Int
        
        func encodeBase64() -> String {
            let data = NSMutableData()
            let archiver = NSKeyedArchiver(forWritingWith: data)
            archiver.encode(messageEncrypted, forKey: "messageEncrypted")
            archiver.encode(blockSize, forKey: "blockSize")
            archiver.encode(messageEncryptedSize, forKey: "messageEncryptedSize")
            archiver.finishEncoding()
            return (data as Data).base64EncodedString()
        }
        
        init(messageEncrypted: [UInt8], blockSize: Int, messageEncryptedSize: Int) {
            self.messageEncrypted = messageEncrypted
            self.blockSize = blockSize
            self.messageEncryptedSize = messageEncryptedSize
        }
        
        init?(_ base64Encoded: String) {
            guard let data = Data.init(base64Encoded: base64Encoded) else {return nil}
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            defer {
                unarchiver.finishDecoding()
            }
            guard
                let messageEncrypted = unarchiver.decodeObject(forKey: "messageEncrypted") as? [UInt8],
                let blockSize = unarchiver.decodeObject(forKey: "blockSize") as? Int,
                let messageEncryptedSize = unarchiver.decodeObject(forKey: "messageEncryptedSize") as? Int
            else { return nil }
            self.init(messageEncrypted: messageEncrypted, blockSize: blockSize, messageEncryptedSize: messageEncryptedSize)
        }
        
        static func fromData(_ flattened: Data) -> EncryptedData? {
            return NSKeyedUnarchiver.unarchiveObject(with: flattened) as? EncryptedData
        }
    }
    
    static func generateKeys() -> KeyPair? {
        //Generation of RSA private and public keys
        let parameters: [String: AnyObject] = [
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeySizeInBits as String: 1024 as AnyObject
        ]
        
        var publicKey, privateKey: SecKey?
        
        SecKeyGeneratePair(
            parameters as CFDictionary,
            &publicKey,
            &privateKey
        )
        
        guard
            let publicSecKey = publicKey,
            let privateSecKey = privateKey
        else {return nil}
        
        let pu = SendableKey(publicSecKey)
        let pr = SendableKey(privateSecKey)
        
        return KeyPair(publicKey: pu, privateKey: pr)
    }
    
    
    static func encrypt(
        publicKey: SendableKey,
        message: String
    ) -> EncryptedData? {
        
        //Encrypt a string with the public key
        let blockSize = SecKeyGetBlockSize(publicKey.raw)
        var messageEncrypted = [UInt8](repeating: 0, count: blockSize)
        var messageEncryptedSize = blockSize
        
        let status: OSStatus! = SecKeyEncrypt(
            publicKey.raw,
            SecPadding.PKCS1,
            message,
            message.count,
            &messageEncrypted,
            &messageEncryptedSize
        )
        
        if status != noErr {
            print("Encryption Error!")
            return nil
        }
        
        return EncryptedData(
            messageEncrypted: messageEncrypted,
            blockSize: blockSize,
            messageEncryptedSize: messageEncryptedSize
        )
    }
    
    
    static func decrypt(
        privateKey: SendableKey,
        encryptedData: EncryptedData
    ) -> NSString? {
        //Decrypt the entrypted string with the private key
        var messageEncrypted = encryptedData.messageEncrypted
        var messageDecrypted = [UInt8](repeating: 0, count: encryptedData.blockSize)
        var messageDecryptedSize = encryptedData.messageEncryptedSize
        
        Sec
        
        let status: OSStatus! = SecKeyDecrypt(
            privateKey.raw,
            SecPadding.PKCS1,
            &messageEncrypted,
            encryptedData.messageEncryptedSize,
            &messageDecrypted,
            &messageDecryptedSize
        )
        
        if status != noErr {
            print("Decryption Error!")
            return nil
        }
        
        guard let decoded = NSString(
            bytes: &messageDecrypted,
            length: messageDecryptedSize,
            encoding: String.Encoding.utf8.rawValue
        ) else {return nil}
        
        return decoded
    }
    
}
