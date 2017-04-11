//
//  Sweets.swift
//  FireSwiffer
//
//  Created by andrey on 2/28/17.
//  Copyright © 2017 andrey. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    
    
    
    init(content:String, addedByUser:String, key:String = "") {
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    init(snapshot:FIRDataSnapshot) {
        
        key = snapshot.key
        itemRef = snapshot.ref
        
        let snapshotvalue = snapshot.value as? NSDictionary
        if let sweetContent = snapshotvalue?["content"] as? String{
            content = sweetContent
        }else{
            content = ""
        }
        
        if let sweetUser = snapshotvalue?["addedByUser"] as? String{
            addedByUser = sweetUser
        }else{
            addedByUser = ""
        }
        
        
    }
    
    func toAnyObject() -> Any {
        return ["content":content, "addedByUser":addedByUser]
    }
    
}
