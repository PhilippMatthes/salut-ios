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
    
    var devices = [MCPeerID]()
    var code: String!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        code = UserDefaults.standard.object(forKey: "code") as? String ?? String.random(length: 8)
        UserDefaults.standard.set(code, forKey: "code")
        salut = SalutServer(peerId: MCPeerID(displayName: Host.current().name ?? "Mac"), password: code.md5())
        salut.delegate = self
        salut.prepare()
        setMenu(code)
        addButton()
    }
    
    func setMenu(_ code: String) {
        let menu = NSMenu()
        menu.addItem(withTitle: "Available Devices:", action: nil, keyEquivalent: "")
        for device in devices {
            menu.addItem(withTitle: "\(device.displayName)", action: nil, keyEquivalent: "")
        }
        menu.addItem(withTitle: "Send disconnect request", action: #selector(AppDelegate.disconnectAllDevices), keyEquivalent: "D")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(withTitle: "Code: \(code)", action: nil, keyEquivalent: "")
        menu.addItem(withTitle: "Reset Code", action: #selector(AppDelegate.resetCode), keyEquivalent: "R")
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        statusItem.menu = menu
    }
    
    func addButton() {
        if let button = statusItem.button {
            button.target = self
            button.image = NSImage(named: NSImage.Name("status"))
        }
    }
    
    @objc func disconnectAllDevices() {
        salut.sendInvalidateConnection()
    }
    
    @objc func resetCode() {
        code = String.random(length: 8)
        UserDefaults.standard.set(code, forKey: "code")
        setMenu(code)
        salut.setPassword(code.md5())
    }
    
    @objc func quit() {
        salut.sendInvalidateConnection()
        salut.postpare()
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
    func server(_ server: SalutServer, didChangeConnectedDevices connectedDevices: [MCPeerID]) {
        devices = connectedDevices
        setMenu(code)
    }
    
    func server(_ server: SalutServer, sentInvalidateConnection package: Package) {
        
    }
    
    func server(_ server: SalutServer, receivedSearchRequest package: Package) {
        print("Received search request.")
    }
    
    func server(_ server: SalutServer, sentSearchResponse package: Package) {
        print("Sent search response.")
        notificate(title: "New trusted connection", content: "Mac Connect established a new encrypted connection.")
    }
    
    func server(_ server: SalutServer, receivedDataTransmission package: Package) {
        print("Received data transmission.")
    }
    
    func server(_ server: SalutServer, receivedDecryptedTransmission data: String) {
        print("Received decrypted transmission.")
        guard let keyCode: UInt16 = UInt16(data) else {return}
        triggerKeyDown(keyCode)
    }
}

extension AppDelegate: NSUserNotificationCenterDelegate {
    func notificate(title: String, content: String) {
        let notification = NSUserNotification()
        notification.title = title
        notification.subtitle = content
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }
}

