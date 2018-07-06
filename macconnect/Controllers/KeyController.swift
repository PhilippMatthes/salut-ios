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

    var salut: SalutClient!
    var hashedCode: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.register(KeyCell.classForCoder(), forCellReuseIdentifier: KeyCell.identifier)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        salut = SalutClient(peerId: MCPeerID(displayName: UIDevice.current.name), password: hashedCode)
        salut.delegate = self
        salut.prepare()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        salut.postpare()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KeyCode.all.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        salut.sendData(String(KeyCode.all[indexPath.row].code))
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: KeyCell.identifier) as? KeyCell else {return UITableViewCell()}
        cell.configure(name: KeyCode.all[indexPath.row].name)
        return cell
    }
    
}

extension KeyController: SalutClientDelegate {
    func client(_ client: SalutClient, didChangeConnectedDevices connectedDevices: [String]) {
        
    }
    
    func client(_ client: SalutClient, sentSearchRequest package: Package) {
        print("Client sent search request.")
    }
    
    func client(_ client: SalutClient, receivedSearchResponse package: Package) {
        print("Client received search response.")
    }
    
    func client(_ client: SalutClient, recievedDecryptableSearchResponse response: String) {
        print("Client received decryptable search response.")
    }
    
    func client(_ client: SalutClient, sentData package: Package) {
        print("Client sent data.")
    }
}

