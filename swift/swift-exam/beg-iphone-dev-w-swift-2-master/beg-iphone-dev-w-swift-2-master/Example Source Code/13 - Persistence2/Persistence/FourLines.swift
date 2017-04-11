//
//  FourLines.swift
//  Persistence
//
//  Created by Kim Topley on 10/25/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import Foundation

class FourLines : NSObject, NSCoding, NSCopying {
    fileprivate static let linesKey = "linesKey"
    var lines:[String]?
    
    override init() {
    }
    
    required init(coder decoder: NSCoder) {
        lines = decoder.decodeObject(forKey: FourLines.linesKey) as? [String]
    }
    
    func encode(with coder: NSCoder) {
        if let saveLines = lines {
            coder.encode(saveLines, forKey: FourLines.linesKey)
        }
    }
    
    func copy(with zone: NSZone?) -> Any {
        let copy = FourLines()
        if let linesToCopy = lines {
            var newLines = Array<String>()
            for line in linesToCopy {
                newLines.append(line)
            }
            copy.lines = newLines
        }
        return copy
    }
}
