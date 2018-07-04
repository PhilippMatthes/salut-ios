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
    @IBOutlet weak var hiLabel: UILabel!
    
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
        
        hiLabel.font = RobotoFont.bold(with: 90.0)
        button.titleLabel?.font = RobotoFont.bold(with: 20.0)
        button.backgroundColor = Color.grey.lighten3
        input.textColor = .white
        input.detailColor = .white
        input.dividerActiveColor = .white
        input.tintColor = .white
        input.dividerColor = .white
        input.placeholder = "Enter Code"
        input.placeholderActiveColor = .white
    }
    
    @IBAction func submit(_ sender: Any) {
        if let code = input.text {
            let hashedCode = code.md5()
            salut.setPassword(hashedCode)
            salut.sendSearchRequest()
        }
    }
}

extension ConnectionController: SalutClientDelegate {
    
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
