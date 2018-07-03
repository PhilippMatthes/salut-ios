//
//  ViewController.swift
//  macconnect
//
//  Created by Philipp Matthes on 01.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import UIKit
import Material
import MultipeerConnectivity

class KeyController: TableViewController {
    
    static let identifier = "KeyController"

    let salut = SalutClient(peerId: MCPeerID(displayName: UIDevice.current.name), password: "secret")

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(KeyCell.classForCoder(), forCellReuseIdentifier: KeyCell.identifier)
        tableView.reloadData()
        salut.delegate = self
        salut.prepare()
        salut.sendConnectionRequest()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KeyCode.all.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        salut.sendEncryptedDataTransmission(message: String(KeyCode.all[indexPath.row].1))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KeyCell.identifier) as? KeyCell else {return UITableViewCell()}
        cell.configure(name: KeyCode.all[indexPath.row].0)
        return cell
    }
    
}

extension KeyController: SalutClientDelegate {
    func client(_ client: SalutClient, sentConnectionRequest package: Package) {
        
    }
    
    func client(_ client: SalutClient, receivedConnectionResponse package: Package) {
        
    }
    
    func client(_ client: SalutClient, sentEncryptedPasswordRequest package: Package) {
        
    }
    
    func client(_ client: SalutClient, receivedEncryptedPasswordState passwordState: Salut.PasswordState) {
        
    }
    
    func client(_ client: SalutClient, sentEncryptedDataTransmission package: Package) {
        
    }
    
    func client(_ client: SalutClient, receivedEncryptedInvalidateConnections package: Package) {
        
    }
    
    
}

