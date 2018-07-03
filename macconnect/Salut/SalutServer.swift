//
//  SalutServer.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation

protocol SalutServerDelegate {
    func server(_ server: SalutServer, receivedConnectionRequest package: Package)
    func server(_ server: SalutServer, sentConnectionResponse package: Package)
    func server(_ server: SalutServer, receivedEncryptedPasswordRequest package: Package)
    func server(_ server: SalutServer, sentEncryptedPasswordResponse package: Package)
    func server(_ server: SalutServer, receivedEncryptedTransmission decryptedTransmission: String)
    func server(_ server: SalutServer, sentEncryptedInvalidateConnections package: Package)
}

class SalutServer: Salut {
    
    var delegate: SalutServerDelegate?
    var receivedPublicClientKey: String?
    
    func prepare() {
        bonjour.delegate = self
    }
    
    func receivedConnectionRequest(package: Package) {
        delegate?.server(self, receivedConnectionRequest: package)
        let publicKey = package.contents
        receivedPublicClientKey = publicKey
        sendConnectionResponse()
    }
    
    func sendConnectionResponse() {
        guard let publicKeyEncoded = keyPair.publicKey.encodeBase64() else {return}
        let package = Package(contents: publicKeyEncoded, header: Header.connectionResponse.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.server(self, sentConnectionResponse: package)
    }
    
    func receivedEncryptedPasswordRequest(package: Package) {
        delegate?.server(self, receivedEncryptedPasswordRequest: package)
        let passwordBase64Encoded = package.contents
        guard
            let passwordEncrypted = RSA.EncryptedData(passwordBase64Encoded),
            let passwordDecrypted = RSA.decrypt(privateKey: keyPair.privateKey, encryptedData: passwordEncrypted)
            else {return}
        if passwordDecrypted as String == password {
            sendEncryptedPasswordResponse(passwordState: .correct)
        } else {
            sendEncryptedPasswordResponse(passwordState: .incorrect)
        }
    }
    
    func sendEncryptedPasswordResponse(passwordState: PasswordState) {
        guard
            let receivedPublicClientKey = receivedPublicClientKey,
            let publicClientKey = RSA.SendableKey(receivedPublicClientKey),
            let stateEncrypted = RSA.encrypt(publicKey: publicClientKey, message: passwordState.rawValue)
            else {return}
        let package = Package(contents: stateEncrypted.encodeBase64(), header: Header.encryptedPasswordResponse.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.server(self, sentEncryptedPasswordResponse: package)
    }
    
    func receivedEncryptedDataTransmission(package: Package) {
        guard
            let encryptedData = RSA.EncryptedData(package.contents),
            let transmissionDecrypted = RSA.decrypt(privateKey: keyPair.privateKey, encryptedData: encryptedData)
        else {return}
        delegate?.server(self, receivedEncryptedTransmission: transmissionDecrypted as String)
    }
    
    func sendInvalidateTransmissions() {
        guard
            let receivedPublicClientKey = receivedPublicClientKey,
            let publicClientKey = RSA.SendableKey(receivedPublicClientKey),
            let invalidationMessage = RSA.encrypt(publicKey: publicClientKey, message: "Invalidate")
        else {return}
        let package = Package(contents: invalidationMessage.encodeBase64(), header: Header.encryptedInvalidateHosts.rawValue)
        bonjour.send(package.encodeBase64())
        delegate?.server(self, sentEncryptedInvalidateConnections: package)
    }
    
}

extension SalutServer: BonjourDelegate {
    func manager(_ manager: Bonjour, didChangeConnectedDevices connectedDevices: [String]) {
        // Nothing
    }
    
    func manager(_ manager: Bonjour, transmittedPayload payload: String) {
        guard let package = Package(payload) else {return}
        switch package.header {
            case Header.connectionRequest.rawValue:
                receivedConnectionRequest(package: package)
            case Header.encryptedPasswordRequest.rawValue:
                receivedEncryptedPasswordRequest(package: package)
            case Header.encryptedDataTransmission.rawValue:
                receivedEncryptedDataTransmission(package: package)
            default:
                break
        }
    }
}

