//
//  Package.swift
//  macconnect
//
//  Created by Philipp Matthes on 02.07.18.
//  Copyright © 2018 Philipp Matthes. All rights reserved.
//

import Foundation

class Package {
    let contents: String
    let header: String
    
    init(contents: String, header: String) {
        self.contents = contents
        self.header = header
    }
    
    func encodeBase64() -> String {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(contents, forKey: "contents")
        archiver.encode(header, forKey: "header")
        archiver.finishEncoding()
        return (data as Data).base64EncodedString()
    }
    
    convenience init?(_ base64Encoded: String) {
        guard let data = Data.init(base64Encoded: base64Encoded) else {return nil}
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        defer {
            unarchiver.finishDecoding()
        }
        guard
            let contents = unarchiver.decodeObject(forKey: "contents") as? String,
            let header = unarchiver.decodeObject(forKey: "header") as? String
            else { return nil }
        self.init(contents: contents, header: header)
    }
}
