//
//  AppDelegate.swift
//  macconnect-mac
//
//  Created by Philipp Matthes on 01.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Cocoa
import MultipeerConnectivity

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    let salut = SalutServer(peerId: MCPeerID(displayName: Host.current().name ?? "Mac"), password: "secret")

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        salut.delegate = self
        salut.prepare()
        addMenu()
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func addMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.target = self
            button.image = NSImage(named: NSImage.Name("status"))
        }
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }

    func triggerKeyDown(_ keyCode: UInt16) {
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let cmd = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: true)
        let cmdDown = CGEvent(keyboardEventSource: src, virtualKey: keyCode, keyDown: false)
        let loc = CGEventTapLocation.cghidEventTap
        cmd?.post(tap: loc)
        cmdDown?.post(tap: loc)
    }
}

extension AppDelegate: SalutServerDelegate {
    func server(_ server: SalutServer, receivedConnectionRequest package: Package) {
        
    }
    
    func server(_ server: SalutServer, sentConnectionResponse package: Package) {
        
    }
    
    func server(_ server: SalutServer, receivedEncryptedPasswordRequest package: Package) {
        
    }
    
    func server(_ server: SalutServer, sentEncryptedPasswordResponse package: Package) {
        
    }
    
    func server(_ server: SalutServer, receivedEncryptedTransmission decryptedTransmission: String) {
        print("Received transmission: \(decryptedTransmission)")
        guard let keyCode: UInt16 = UInt16(decryptedTransmission) else {return}
        triggerKeyDown(keyCode)
    }
    
    func server(_ server: SalutServer, sentEncryptedInvalidateConnections package: Package) {
        
    }
}

