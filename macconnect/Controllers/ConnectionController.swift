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
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var table: TableView!
    @IBOutlet weak var keyBoardSelection: UISegmentedControl!
    
    var clients = [MCPeerID]()
    
    var salut: SalutClient?
    var keyBoardLocale: KeyCode.Locale!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let code = UserDefaults.standard.object(forKey: "code") as? String ?? ""
        
        prepareSalut(code)
        prepareButton()
        prepareInput(code)
        prepareTable()
        
        hideButton()
        showSegmentedControl()
    }
    
    func prepareSalut(_ code: String) {
        let hashedCode = code.md5()
        if salut == nil {
            salut = SalutClient(peerId: MCPeerID(displayName: UIDevice.current.name), password: hashedCode)
            salut!.prepare()
            salut!.sendSearchRequest()
        }
        
        salut!.delegate = self
    }
    
    func prepareButton() {
        button.titleLabel?.font = RobotoFont.bold(with: 20.0)
        button.backgroundColor = .white
        setLoginButtonState(active: clients.count > 0)
        button.layer.cornerRadius = button.layer.frame.height / 2
    }
    
    func prepareInput(_ code: String) {
        input.text = code
        input.textColor = .white
        input.detailColor = .white
        input.dividerActiveColor = .white
        input.tintColor = .white
        input.dividerColor = .white
    }
    
    func prepareTable() {
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = .clear
        table.reloadData()
        table.transform = CGAffineTransform(scaleX: 1, y: -1)
        table.layer.zPosition = -1
        table.isUserInteractionEnabled = false
    }
    
    func hideButton() {
        button.isHidden = true
    }
    
    func showButton() {
        button.isHidden = false
    }
    
    func hideSegmentedControl() {
        keyBoardSelection.isHidden = true
    }
    
    func showSegmentedControl() {
        keyBoardSelection.selectedSegmentIndex = UISegmentedControlNoSegment
        keyBoardSelection.isHidden = false
    }
    
    @IBAction func submit(_ sender: Any) {
        if clients.count > 0 {
            if let code = input.text {
                let hashedCode = code.md5()
                salut!.setPassword(hashedCode)
                salut!.sendSearchRequest()
            }
        }
    }
    
    @IBAction func keyBoardSelectionChanged(_ sender: UISegmentedControl) {
        keyBoardLocale = sender.selectedSegmentIndex == 0 ? .US : .DE
        hideSegmentedControl()
        showButton()
    }
    
    func setLoginButtonState(active: Bool) {
        self.button.setTitle(active ? "Login" : "Waiting for peers", for: .normal)
    }
}

extension ConnectionController: SalutClientDelegate {
    func client(_ client: SalutClient, didChangeConnectedDevices connectedDevices: [MCPeerID]) {
        DispatchQueue.main.async {
            self.setLoginButtonState(active: connectedDevices.count > 0)
            self.clients = connectedDevices
            self.table.reloadData()
        }
    }
    
    func client(_ client: SalutClient, receivedInvalidateConnection package: Package) {
        
    }
    
    func client(_ client: SalutClient, recievedDecryptableInvalidateConnection response: String) {
        
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
            guard let input = self.input.text else {return}
            guard let salut = self.salut else {return}
            let controllers = KeyType.all().map {KeyController($0, salut, self.keyBoardLocale)}
            UserDefaults.standard.set(input, forKey: "code")
            let tabsController = TabsViewController(viewControllers: controllers)
            self.present(tabsController, animated: true, completion: nil)
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
        cell.textLabel?.text = clients[indexPath.row].displayName
        cell.layer.cornerRadius = cell.layer.frame.height / 2
        cell.layer.borderColor = UIColor(rgb: 0x7CD201, alpha: 1.0).cgColor
        cell.layer.borderWidth = 3.0
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        cell.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            cell.alpha = 1.0
        })
        return cell
    }
    
}
