//
//  LoginViewController.swift
//  Mate
//
//  Created by Dan Kim on 6/26/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  let loginToEmail = "LoginToEmail"
  
  // MARK: Properties
  var userEmail: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    try! FIRAuth.auth()!.signOut()
    FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
      if user != nil {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    let navVc = segue.destination as! UINavigationController
    let roomListVc = navVc.viewControllers.first as! RoomListTableViewController
    
    roomListVc.senderDisplayName = userEmail
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Actions
  @IBAction func facebookLoginAction(_ sender: Any) {
    self.facebookLogin()
  }
  
  @IBAction func emailLoginAction(_ sender: Any) {
    self.performSegue(withIdentifier: self.loginToEmail, sender: nil)
  }
  
  func facebookLogin() {
    let fbLoginManager:FBSDKLoginManager = FBSDKLoginManager()
    fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
      if error != nil {
        print("Process error")
      } else if result?.isCancelled == true {
        print("Cancelled")
      } else {
        print("Logged in")
        self.signInToFirebase()
        self.getFBUserData()
      }
    }
  }
  
  func getFBUserData() {
    if FBSDKAccessToken.current() != nil {
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
        if error == nil {
          print(result as Any)
        }
      })
    }
  }
  
  func signInToFirebase() {
    let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
      print("Sign in to Firebase")
    })
  }
}
