//
//  Key.swift
//  macconnect
//
//  Created by Philipp Matthes on 01.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import Material

class KeyCell: CollectionViewCell {
    static let identifier = "KeyCell"
    
    func configure(_ key: Key) {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        let label = UILabel()
        label.frame = key.imageString == nil ? contentView.frame : CGRect(
            center: contentView.frame.center,
            size: CGSize(
                width: contentView.frame.width,
                height: contentView.frame.height - 25
            )
        )
        label.bounds = key.imageString == nil ? contentView.bounds : CGRect(
            center: contentView.bounds.center,
            size: CGSize(
                width: contentView.bounds.width,
                height: contentView.bounds.height - 25
            )
        )
        label.center = key.imageString == nil ? contentView.center : CGPoint(x: contentView.center.x, y: contentView.center.y + 15)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = key.name
        label.textColor = .black
        if key.imageString != nil {
            label.font = RobotoFont.bold(with: 10)
        } else if key.name.count <= 1 {
            label.font = RobotoFont.bold(with: 25)
        } else {
            label.font = RobotoFont.bold(with: 15)
        }
        addSubview(label)
        
        if let imageString = key.imageString {
            let imageLabel = UILabel()
            
            imageLabel.frame = key.imageString == nil ? contentView.frame : CGRect(
                center: contentView.frame.center,
                size: CGSize(
                    width: contentView.frame.width,
                    height: contentView.frame.height - 25
                )
            )
            imageLabel.bounds = key.imageString == nil ? contentView.bounds : CGRect(
                center: contentView.bounds.center,
                size: CGSize(
                    width: contentView.bounds.width,
                    height: contentView.bounds.height - 25
                )
            )
            imageLabel.center = key.imageString == nil ? contentView.center : CGPoint(x: contentView.center.x, y: contentView.center.y - 15)
            imageLabel.numberOfLines = 0
            imageLabel.textAlignment = .center
            imageLabel.text = imageString
            imageLabel.textColor = .black
            addSubview(imageLabel)
        }
        
        backgroundColor = .white
        pulseColor = Color.grey.base
        layer.cornerRadius = 5.0
    }
}

enum KeyType: String {
    case alphanumeric = "Alphanum."
    case special = "Special"
    case control = "Control"
    
    static func all() -> [KeyType] {
        return [.alphanumeric, .special, .control]
    }
}

struct Key {
    let name: String
    let code: UInt16
    let imageString: String?
    let types: [KeyType]
    
    init(_ name: String, _ code: UInt16, _ types: KeyType..., imageString: String? = nil) {
        self.name = name
        self.code = code
        self.types = types
        self.imageString = imageString
    }
}

struct KeyCode {
        // Layout-independent Keys
        // eg.These key codes are always the same key on all layouts.
        // Source: https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066
    
    enum Locale {
        case US
        case DE
    }
    
    static let US: [Key] = [
        Key("Return", 0x24, .control, imageString: "↵"),
        Key("Tab", 0x30, .control, imageString: "⇥"),
        Key("Space", 0x31, .control, imageString: "␣"),
        Key("Del", 0x33, .control, imageString: "⌫"),
        Key("Esc", 0x35, .control, imageString: "⎋"),
        Key("Cmd", 0x37, .control, imageString: "⌘"),
        Key("Shift", 0x38, .control, imageString: "⇧"),
        Key("Caps Lock", 0x39, .control, imageString: "⇪"),
        Key("Option", 0x3A, .control, imageString: "⌥"),
        Key("Ctrl", 0x3B, .control, imageString: "⌃"),
        Key("Left Arrow", 0x7B, .control, imageString: "←"),
        Key("Right Arrow", 0x7C, .control, imageString: "→"),
        Key("Down Arrow", 0x7D, .control, imageString: "↓"),
        Key("Up Arrow", 0x7E, .control, imageString: "↑"),
        Key("Home", 0x73, .control, imageString: "↖"),
        Key("Forward Delete", 0x75, .control, imageString: "⌦"),
        Key("End", 0x77, .control, imageString: "↘"),
        Key("Page Up", 0x74, .control),
        Key("Page Down", 0x79, .control),
        Key("Help", 0x72, .control),
        
        Key("fn", 0x3F, .special),
        Key("F1", 0x7A, .special),
        Key("F2", 0x78, .special),
        Key("F4", 0x76, .special),
        Key("F5", 0x60, .special),
        Key("F6", 0x61, .special),
        Key("F7", 0x62, .special),
        Key("F3", 0x63, .special),
        Key("F8", 0x64, .special),
        Key("F9", 0x65, .special),
        Key("F10", 0x6D, .special),
        Key("F11", 0x67, .special),
        Key("F12", 0x6F, .special),
        Key("F13", 0x69, .special),
        Key("F14", 0x6B, .special),
        Key("F15", 0x71, .special),
        Key("F16", 0x6A, .special),
        Key("F17", 0x40, .special),
        Key("F18", 0x4F, .special),
        Key("F19", 0x50, .special),
        Key("F20", 0x5A, .special),
        
        // US-ANSI Keyboard Positions
        // eg. These key codes are for the physical key (in any keyboard layout)
        // at the location of the named key in the US-ANSI layout.
        Key("a", 0x00, .alphanumeric),
        Key("b", 0x0B, .alphanumeric),
        Key("c", 0x08, .alphanumeric),
        Key("d", 0x02, .alphanumeric),
        Key("e", 0x0E, .alphanumeric),
        Key("f", 0x03, .alphanumeric),
        Key("g", 0x05, .alphanumeric),
        Key("h", 0x04, .alphanumeric),
        Key("i", 0x22, .alphanumeric),
        Key("j", 0x26, .alphanumeric),
        Key("k", 0x28, .alphanumeric),
        Key("l", 0x25, .alphanumeric),
        Key("m", 0x2E, .alphanumeric),
        Key("n", 0x2D, .alphanumeric),
        Key("o", 0x1F, .alphanumeric),
        Key("p", 0x23, .alphanumeric),
        Key("q", 0x0C, .alphanumeric),
        Key("r", 0x0F, .alphanumeric),
        Key("s", 0x01, .alphanumeric),
        Key("t", 0x11, .alphanumeric),
        Key("u", 0x20, .alphanumeric),
        Key("v", 0x09, .alphanumeric),
        Key("w", 0x0D, .alphanumeric),
        Key("x", 0x07, .alphanumeric),
        Key("y", 0x10, .alphanumeric),
        Key("z", 0x06, .alphanumeric),
        
        Key("0", 0x1D, .alphanumeric),
        Key("1", 0x12, .alphanumeric),
        Key("2", 0x13, .alphanumeric),
        Key("3", 0x14, .alphanumeric),
        Key("4", 0x15, .alphanumeric),
        Key("5", 0x17, .alphanumeric),
        Key("6", 0x16, .alphanumeric),
        Key("7", 0x1A, .alphanumeric),
        Key("8", 0x1C, .alphanumeric),
        Key("9", 0x19, .alphanumeric),
        
        Key("=", 0x18, .special),
        Key("-", 0x1B, .special),
        Key(";", 0x29, .special),
        Key("'", 0x27, .special),
        Key(",", 0x2B, .special),
        Key(".", 0x2F, .special),
        Key("/", 0x2C, .special),
        Key("\\", 0x2A, .special),
        Key("`", 0x32, .special),
        Key("[", 0x21, .special),
        Key("]", 0x1E, .special),
        
        Key(",", 0x41, .special),
        Key("*", 0x43, .special),
        Key("+", 0x45, .special),
        Key("/", 0x4B, .special),
        Key("↵", 0x4C, .special),
        Key("-", 0x4E, .special),
        Key("=", 0x51, .special),
        Key("0", 0x52, .special),
        Key("1", 0x53, .special),
        Key("2", 0x54, .special),
        Key("3", 0x55, .special),
        Key("4", 0x56, .special),
        Key("5", 0x57, .special),
        Key("6", 0x58, .special),
        Key("7", 0x59, .special),
        Key("8", 0x5B, .special),
        Key("9", 0x5C, .special),
    ]
    
    static let DE: [Key] = [
        Key("Return", 0x24, .control, imageString: "↵"),
        Key("Tab", 0x30, .control, imageString: "⇥"),
        Key("Space", 0x31, .control, imageString: "␣"),
        Key("Del", 0x33, .control, imageString: "⌫"),
        Key("Esc", 0x35, .control, imageString: "⎋"),
        Key("Cmd", 0x37, .control, imageString: "⌘"),
        Key("Shift", 0x38, .control, imageString: "⇧"),
        Key("Caps Lock", 0x39, .control, imageString: "⇪"),
        Key("Option", 0x3A, .control, imageString: "⌥"),
        Key("Ctrl", 0x3B, .control, imageString: "⌃"),
        Key("Left Arrow", 0x7B, .control, imageString: "←"),
        Key("Right Arrow", 0x7C, .control, imageString: "→"),
        Key("Down Arrow", 0x7D, .control, imageString: "↓"),
        Key("Up Arrow", 0x7E, .control, imageString: "↑"),
        Key("Home", 0x73, .control, imageString: "↖"),
        Key("Forward Delete", 0x75, .control, imageString: "⌦"),
        Key("End", 0x77, .control, imageString: "↘"),
        Key("Page Up", 0x74, .control),
        Key("Page Down", 0x79, .control),
        Key("Help", 0x72, .control),
        
        Key("fn", 0x3F, .special),
        Key("F1", 0x7A, .special),
        Key("F2", 0x78, .special),
        Key("F4", 0x76, .special),
        Key("F5", 0x60, .special),
        Key("F6", 0x61, .special),
        Key("F7", 0x62, .special),
        Key("F3", 0x63, .special),
        Key("F8", 0x64, .special),
        Key("F9", 0x65, .special),
        Key("F10", 0x6D, .special),
        Key("F11", 0x67, .special),
        Key("F12", 0x6F, .special),
        Key("F13", 0x69, .special),
        Key("F14", 0x6B, .special),
        Key("F15", 0x71, .special),
        Key("F16", 0x6A, .special),
        Key("F17", 0x40, .special),
        Key("F18", 0x4F, .special),
        Key("F19", 0x50, .special),
        Key("F20", 0x5A, .special),
        
        // US-ANSI Keyboard Positions
        // eg. These key codes are for the physical key (in any keyboard layout)
        // at the location of the named key in the US-ANSI layout.
        
        Key("a", 0x00, .alphanumeric),
        Key("b", 0x0B, .alphanumeric),
        Key("c", 0x08, .alphanumeric),
        Key("d", 0x02, .alphanumeric),
        Key("e", 0x0E, .alphanumeric),
        Key("f", 0x03, .alphanumeric),
        Key("g", 0x05, .alphanumeric),
        Key("h", 0x04, .alphanumeric),
        Key("i", 0x22, .alphanumeric),
        Key("j", 0x26, .alphanumeric),
        Key("k", 0x28, .alphanumeric),
        Key("l", 0x25, .alphanumeric),
        Key("m", 0x2E, .alphanumeric),
        Key("n", 0x2D, .alphanumeric),
        Key("o", 0x1F, .alphanumeric),
        Key("p", 0x23, .alphanumeric),
        Key("q", 0x0C, .alphanumeric),
        Key("r", 0x0F, .alphanumeric),
        Key("s", 0x01, .alphanumeric),
        Key("t", 0x11, .alphanumeric),
        Key("u", 0x20, .alphanumeric),
        Key("v", 0x09, .alphanumeric),
        Key("w", 0x0D, .alphanumeric),
        Key("x", 0x07, .alphanumeric),
        Key("y", 0x10, .alphanumeric),
        Key("z", 0x06, .alphanumeric),
        
        Key("0", 0x1D, .alphanumeric),
        Key("1", 0x12, .alphanumeric),
        Key("2", 0x13, .alphanumeric),
        Key("3", 0x14, .alphanumeric),
        Key("4", 0x15, .alphanumeric),
        Key("5", 0x17, .alphanumeric),
        Key("6", 0x16, .alphanumeric),
        Key("7", 0x1A, .alphanumeric),
        Key("8", 0x1C, .alphanumeric),
        Key("9", 0x19, .alphanumeric),
        
        Key("´", 0x18, .special),
        Key("ß", 0x1B, .special),
        Key("ö", 0x29, .special),
        Key("ä", 0x27, .special),
        Key(",", 0x2B, .special),
        Key(".", 0x2F, .special),
        Key("-", 0x2C, .special),
        Key("#", 0x2A, .special),
        Key("<", 0x32, .special),
        Key("ü", 0x21, .special),
        Key("+", 0x1E, .special),
        
        Key(",", 0x41, .special),
        Key("*", 0x43, .special),
        Key("+", 0x45, .special),
        Key("/", 0x4B, .special),
        Key("↵", 0x4C, .special),
        Key("-", 0x4E, .special),
        Key("=", 0x51, .special),
        Key("0", 0x52, .special),
        Key("1", 0x53, .special),
        Key("2", 0x54, .special),
        Key("3", 0x55, .special),
        Key("4", 0x56, .special),
        Key("5", 0x57, .special),
        Key("6", 0x58, .special),
        Key("7", 0x59, .special),
        Key("8", 0x5B, .special),
        Key("9", 0x5C, .special),
    ]
}
