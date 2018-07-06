//
//  ConnectionController.swift
//  macconnect
//
//  Created by Philipp Matthes on 03.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import Material
import MultipeerConnectivity

class ConnectionController: UIViewController {
    
    @IBOutlet weak var input: TextField!
    @IBOutlet weak var button: RaisedButton!
    @IBOutlet weak var table: TableView!
    
    var clients = [String]()
    
    var salut: SalutClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let code = UserDefaults.standard.object(forKey: "code") as? String ?? ""
        let hashedCode = code.md5()
        salut = SalutClient(peerId: MCPeerID(displayName: UIDevice.current.name), password: hashedCode)
        input.text = code
        salut.delegate = self
        salut.prepare()
        salut.sendSearchRequest()
        
        button.titleLabel?.font = RobotoFont.bold(with: 20.0)
        button.backgroundColor = .white
        button.setTitle("Waiting for peers", for: .normal)
        input.textColor = .white
        input.detailColor = .white
        input.dividerActiveColor = .white
        input.tintColor = .white
        input.dividerColor = .white
        input.placeholder = "Enter Code"
        input.placeholderActiveColor = .white
        
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.reloadData()
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        table.layer.zPosition = -1
        table.isUserInteractionEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        salut.postpare()
    }
    
    @IBAction func submit(_ sender: Any) {
        if clients.count > 0 {
            if let code = input.text {
                let hashedCode = code.md5()
                salut.setPassword(hashedCode)
                salut.sendSearchRequest()
            }
        }
    }
    
    func setLoginButtonState(active: Bool) {
        DispatchQueue.main.async {
            self.button.setTitle(active ? "Login" : "No devices found", for: .normal)
        }
    }
}

extension ConnectionController: SalutClientDelegate {
    func client(_ client: SalutClient, didChangeConnectedDevices connectedDevices: [String]) {
        setLoginButtonState(active: connectedDevices.count > 0)
        clients = connectedDevices
        DispatchQueue.main.async {self.table.reloadData()}
    }
    
    func client(_ client: SalutClient, sentSearchRequest package: Package) {
        print("Client sent search request: \(package.description)")
    }
    
    func client(_ client: SalutClient, receivedSearchResponse package: Package) {
        print("Client received search response: \(package.description)")
    }
    
    func client(_ client: SalutClient, recievedDecryptableSearchResponse response: String) {
        print("Client received decryptable search response: \(response)")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "KeyController") as! KeyController
            if let input = self.input.text {
                controller.hashedCode = input.md5()
                UserDefaults.standard.set(input, forKey: "code")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    func client(_ client: SalutClient, sentData package: Package) {
        print("Client sent data: \(package.description)")
    }
    
    
}

extension ConnectionController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else {return UITableViewCell()}
        cell.textLabel?.text = clients[indexPath.row]
        cell.layer.cornerRadius = cell.layer.frame.height / 2
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            cell.alpha = 1.0
        })
        return cell
    }
    
}
