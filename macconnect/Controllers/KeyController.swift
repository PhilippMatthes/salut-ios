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

class KeyController: CollectionViewController {
    
    static let identifier = "KeyController"

    var salut: SalutClient!
    
    var keyType: KeyType!
    var keys: [Key]!
    
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        
        _flowLayout.itemSize = CGSize(width: 60, height: 60)
        _flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8)
        _flowLayout.scrollDirection = .vertical
        _flowLayout.minimumInteritemSpacing = 0.0
        
        return _flowLayout
    }
    
    convenience init(_ keyType: KeyType, _ salutClient: SalutClient, _ keyBoardLocale: KeyCode.Locale) {
        self.init()
        self.keyType = keyType
        self.salut = salutClient
        
        switch keyBoardLocale {
        case .US:
            keys = KeyCode.US.filter {$0.types.contains(keyType)}
        case .DE:
            keys = KeyCode.DE.filter {$0.types.contains(keyType)}
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        prepareNotificationCenter()
        prepareTabItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        salut.delegate = self
    }
    
    func prepareCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(KeyCell.classForCoder(), forCellWithReuseIdentifier: KeyCell.identifier)
        collectionView.backgroundColor = UIColor(rgb: 0x7CD201, alpha: 1.0)
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.reloadData()
    }
    
    func prepareNotificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func prepareTabItem() {
        tabItem.title = keyType.rawValue
        tabItem.titleColor = Color.grey.darken3
    }
    
    @objc func appMovedToBackground() {
        moveBackToConnectionController()
    }
    
    func moveBackToConnectionController() {
        DispatchQueue.main.async {
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        salut.sendData(String(keys[indexPath.row].code))
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as! KeyCell
        cell.configure(keys[indexPath.row])
        return cell
    }
    
}

extension KeyController: SalutClientDelegate {
    func client(_ client: SalutClient, didChangeConnectedDevices connectedDevices: [MCPeerID]) {
        print("Client did change connected devices.")
    }
    
    func client(_ client: SalutClient, recievedDecryptableInvalidateConnection response: String) {
        moveBackToConnectionController()
    }
    
    func client(_ client: SalutClient, receivedInvalidateConnection package: Package) {
        
    }
    
    func client(_ client: SalutClient, sentSearchRequest package: Package) {
        
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

