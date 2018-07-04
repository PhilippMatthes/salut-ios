//
//  Key.swift
//  macconnect
//
//  Created by Philipp Matthes on 01.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation
import Material

class KeyCell: TableViewCell {
    static let identifier = "KeyCell"
    
    func configure(name: String) {
        textLabel?.textAlignment = .center
        
        let splitted = name
            .splitBefore(separator: { $0.isUpperCase })
            .map{String($0).capitalized}
        
        let concatenated = splitted.joined(separator: " ")
        
        textLabel?.text = concatenated
        textLabel?.textColor = .white
        backgroundColor = Color.grey.darken1
        pulseColor = Color.grey.base
        layer.cornerRadius = 10.0
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
}

enum KeyType {
    case keypad
    case number
    case special
    case letter
    case function
    case media
}

struct Key {
    let name: String
    let code: UInt16
    let image: UIImage?
    
    init(_ name: String, _ code: UInt16, _ types: KeyType..., imageName: String? = nil) {
        self.name = name
        self.code = code
        
        if let imageName = imageName {
            image = UIImage(named: imageName)
        } else {
            image = nil
        }
    }
}

struct KeyCode {
        // Layout-independent Keys
        // eg.These key codes are always the same key on all layouts.
        // Source: https://gist.github.com/swillits/df648e87016772c7f7e5dbed2b345066
    static let all: [Key] = [
        Key("Return", 0x24),
        Key("Enter", 0x4C),
        Key("Tab", 0x30),
        Key("Space", 0x31, .media),
        Key("Del", 0x33),
        Key("Esc", 0x35),
        Key("Cmd", 0x37),
        Key("Shift", 0x38),
        Key("Caps Lock", 0x39),
        Key("Option", 0x3A),
        Key("Ctrl", 0x3B),
        Key("Right Shift", 0x3C),
        Key("Right Option", 0x3D),
        Key("Right Control", 0x3E),
        Key("Left Arrow", 0x7B),
        Key("Right Arrow", 0x7C),
        Key("Down Arrow", 0x7D),
        Key("Up Arrow", 0x7E),
        Key("Volume Up", 0x48, .media),
        Key("Volume Down", 0x49, .media),
        Key("Mute", 0x4A, .media),
        Key("Help", 0x72),
        Key("Home", 0x73),
        Key("Page Up", 0x74),
        Key("Forward Delete", 0x75),
        Key("End", 0x77),
        Key("PageDown", 0x79),
        
        Key("Function", 0x3F, .function),
        Key("F1", 0x7A, .function),
        Key("F2", 0x78, .function),
        Key("F4", 0x76, .function),
        Key("F5", 0x60, .function),
        Key("F6", 0x61, .function),
        Key("F7", 0x62, .function),
        Key("F3", 0x63, .function),
        Key("F8", 0x64, .function),
        Key("F9", 0x65, .function),
        Key("F10", 0x6D, .function),
        Key("F11", 0x67, .function),
        Key("F12", 0x6F, .function),
        Key("F13", 0x69, .function),
        Key("F14", 0x6B, .function),
        Key("F15", 0x71, .function),
        Key("F16", 0x6A, .function),
        Key("F17", 0x40, .function),
        Key("F18", 0x4F, .function),
        Key("F19", 0x50, .function),
        Key("F20", 0x5A, .function),
        
        // US-ANSI Keyboard Positions
        // eg. These key codes are for the physical key (in any keyboard layout)
        // at the location of the named key in the US-ANSI layout.
        Key("a", 0x00, .letter),
        Key("b", 0x0B, .letter),
        Key("c", 0x08, .letter),
        Key("d", 0x02, .letter),
        Key("e", 0x0E, .letter),
        Key("f", 0x03, .letter),
        Key("g", 0x05, .letter),
        Key("h", 0x04, .letter),
        Key("i", 0x22, .letter),
        Key("j", 0x26, .letter),
        Key("k", 0x28, .letter),
        Key("l", 0x25, .letter),
        Key("m", 0x2E, .letter),
        Key("n", 0x2D, .letter),
        Key("o", 0x1F, .letter),
        Key("p", 0x23, .letter),
        Key("q", 0x0C, .letter),
        Key("r", 0x0F, .letter),
        Key("s", 0x01, .letter),
        Key("t", 0x11, .letter),
        Key("u", 0x20, .letter),
        Key("v", 0x09, .letter),
        Key("w", 0x0D, .letter),
        Key("x", 0x07, .letter),
        Key("y", 0x10, .letter),
        Key("z", 0x06, .letter),
        
        Key("0", 0x1D, .number),
        Key("1", 0x12, .number),
        Key("2", 0x13, .number),
        Key("3", 0x14, .number),
        Key("4", 0x15, .number),
        Key("5", 0x17, .number),
        Key("6", 0x16, .number),
        Key("7", 0x1A, .number),
        Key("8", 0x1C, .number),
        Key("9", 0x19, .number),
        
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
        
        Key(",", 0x41, .keypad),
        Key("*", 0x43, .keypad),
        Key("+", 0x45, .keypad),
        Key("/", 0x4B, .keypad),
        Key("↵", 0x4C, .keypad),
        Key("-", 0x4E, .keypad),
        Key("=", 0x51, .keypad),
        Key("0", 0x52, .keypad),
        Key("1", 0x53, .keypad),
        Key("2", 0x54, .keypad),
        Key("3", 0x55, .keypad),
        Key("4", 0x56, .keypad),
        Key("5", 0x57, .keypad),
        Key("6", 0x58, .keypad),
        Key("7", 0x59, .keypad),
        Key("8", 0x5B, .keypad),
        Key("9", 0x5C, .keypad),
    ]
}
