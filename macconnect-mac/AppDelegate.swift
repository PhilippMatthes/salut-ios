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
    
    var salut: SalutServer!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let code = UserDefaults.standard.object(forKey: "code") as? String ?? String.random(length: 8)
        UserDefaults.standard.set(code, forKey: "code")
        salut = SalutServer(peerId: MCPeerID(displayName: Host.current().name ?? "Mac"), password: code.md5())
        salut.delegate = self
        salut.prepare()
        addMenu(code)
        addButton()
    }
    
    func addMenu(_ code: String) {
        let menu = NSMenu()
        menu.addItem(withTitle: "Code: \(code)", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Reset Code", action: #selector(AppDelegate.resetCode), keyEquivalent: "R")
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        statusItem.menu = menu
    }
    
    func addButton() {
        if let button = statusItem.button {
            button.target = self
            button.image = NSImage(named: NSImage.Name("status"))
        }
    }
    
    @objc func resetCode() {
        let code = String.random(length: 8)
        UserDefaults.standard.set(code, forKey: "code")
        addMenu(code)
        salut.setPassword(code.md5())
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
    func server(_ server: SalutServer, receivedSearchRequest package: Package) {
        print("Received search request: \(package.description)")
    }
    
    func server(_ server: SalutServer, sentSearchResponse package: Package) {
        print("Sent search response: \(package.description)")
    }
    
    func server(_ server: SalutServer, receivedDataTransmission package: Package) {
        print("Received data transmission: \(package.description)")
    }
    
    func server(_ server: SalutServer, receivedDecryptedTransmission data: String) {
        print("Received decrypted transmission: \(data)")
        guard let keyCode: UInt16 = UInt16(data) else {return}
        triggerKeyDown(keyCode)
    }
}

