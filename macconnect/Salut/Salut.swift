//
//  Salut.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import MultipeerConnectivity


class Salut {
    
    enum Header: String {
        case connectionRequest = "ConnectionRequest"
        case connectionResponse = "ConnectionResponse"
        case encryptedPasswordRequest = "EncryptedPasswordRequest"
        case encryptedPasswordResponse = "EncryptedPasswordResponse"
        case encryptedDataTransmission = "EncryptedDataTransmission"
        case encryptedInvalidateHosts = "EncryptedInvalidateHosts"
    }
    
    enum PasswordState: String {
        case correct = "correct"
        case incorrect = "incorrect"
    }
    
    let keyPair: RSA.KeyPair
    let bonjour: Bonjour
    let password: String
    
    init(peerId: MCPeerID, password: String) {
        keyPair = RSA.generateKeys()!
        bonjour = Bonjour(peerId: peerId)
        self.password = password
    }
    
}
