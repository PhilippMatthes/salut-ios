//
//  SalutClient.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation

protocol SalutClientDelegate {
    func client(_ client: SalutClient, sentConnectionRequest package: Package)
    func client(_ client: SalutClient, receivedConnectionResponse package: Package)
    func client(_ client: SalutClient, sentEncryptedPasswordRequest package: Package)
    func client(_ client: SalutClient, receivedEncryptedPasswordState passwordState: Salut.PasswordState)
    func client(_ client: SalutClient, sentEncryptedDataTransmission package: Package)
    func client(_ client: SalutClient, receivedEncryptedInvalidateConnections package: Package)
}

class SalutClient: Salut {
    
    var delegate: SalutClientDelegate?
    var receivedPublicServerKey: String?
    
    func prepare() {
        bonjour.delegate = self
    }
    
    func sendConnectionRequest() {
        guard let publicKeyEncoded = keyPair.publicKey.encodeBase64() else {return}
        let package = Package(contents: publicKeyEncoded, header: Header.connectionRequest.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.client(self, receivedConnectionResponse: package)
    }
    
    func receivedConnectionResponse(package: Package) {
        delegate?.client(self, receivedConnectionResponse: package)
        let publicKey = package.contents
        receivedPublicServerKey = publicKey
        sendEncryptedPasswordRequest(receivedPublicServerKey: publicKey)
    }
    
    func sendEncryptedPasswordRequest(receivedPublicServerKey publicServerKey: String) {
        guard
            let publicServerKey = RSA.SendableKey(publicServerKey),
            let passwordEncrypted = RSA.encrypt(publicKey: publicServerKey, message: password)
        else {return}
        let passwordBase64Encoded = passwordEncrypted.encodeBase64()
        let package = Package(contents: passwordBase64Encoded, header: Header.encryptedPasswordRequest.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.client(self, sentEncryptedPasswordRequest: package)
    }
    
    func receivedEncryptedPasswortResponse(package: Package) {
        let base64EncryptedPasswordResponse = package.contents
        guard
            let encryptedData = RSA.EncryptedData(base64EncryptedPasswordResponse),
            let decryptedPasswordResponse = RSA.decrypt(privateKey: keyPair.privateKey, encryptedData: encryptedData)
        else {return}
        switch decryptedPasswordResponse as String {
            case Salut.PasswordState.correct.rawValue:
                delegate?.client(self, receivedEncryptedPasswordState: .correct)
            case Salut.PasswordState.incorrect.rawValue:
                delegate?.client(self, receivedEncryptedPasswordState: .incorrect)
            default:
                break
        }
    }
    
    func sendEncryptedDataTransmission(message: String) {
        guard
            let key = receivedPublicServerKey,
            let publicServerKey = RSA.SendableKey(key),
            let encryptedTransmission = RSA.encrypt(publicKey: publicServerKey, message: message)
        else {return}
        let package = Package(contents: encryptedTransmission.encodeBase64(), header: Header.encryptedDataTransmission.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.client(self, sentEncryptedDataTransmission: package)
    }
    
    func receivedEncryptedInvalidateConnections(package: Package) {
        delegate?.client(self, receivedEncryptedInvalidateConnections: package)
        // TODO
    }
}

extension SalutClient: BonjourDelegate {
    func manager(_ manager: Bonjour, didChangeConnectedDevices connectedDevices: [String]) {
        // NOTHING
    }
    
    func manager(_ manager: Bonjour, transmittedPayload payload: String) {
        guard let package = Package(payload) else {return}
        switch package.header {
        case Header.connectionResponse.rawValue:
            receivedConnectionResponse(package: package)
        case Header.encryptedPasswordResponse.rawValue:
            receivedEncryptedPasswortResponse(package: package)
        case Header.encryptedInvalidateHosts.rawValue:
            receivedEncryptedInvalidateConnections(package: package)
        default:
            break
        }
    }
}
