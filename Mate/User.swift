//
//  User.swift
//  Mate
//
//  Created by Dan Kim on 6/26/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import Foundation
import FirebaseAuth

class User {
  
  var uid: String
  var email: String
  var firstName: String?
  var lastName: String?
  var age: Int?
  
  init(authData: FIRUser) {
    uid = authData.uid
    email = authData.email!
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
