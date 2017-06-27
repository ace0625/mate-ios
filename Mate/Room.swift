//
//  Room.swift
//  Mate
//
//  Created by Dan Kim on 6/27/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Room {
    
    var title: String
    var userEmail: String
    let ref: FIRDatabaseReference?
    var completed: Bool
    let key: String
    
    init(title: String, userEmail: String, completed: Bool, key: String = "") {
        self.title = title
        self.userEmail = userEmail
        self.completed = completed
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userEmail = snapshotValue["userEmail"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }

    func toAnyObject() -> Any {
        return [
            "title": title,
            "userEmail": userEmail,
            "completed": completed
        ]
    }
}
