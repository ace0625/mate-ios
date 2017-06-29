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

class LoginViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    try! FIRAuth.auth()!.signOut()
    FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
      if user != nil {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Actions
  @IBAction func facebookLoginAction(_ sender: Any) {
    self.facebookLogin()
  }
  
  @IBAction func loginAction(_ sender: Any) {
    FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!, completion: nil)
  }
  
  @IBAction func signUpAction(_ sender: Any) {
    
    let alert = UIAlertController(title: "Register",
                                  message: "Register",
                                  preferredStyle: .alert)
    
    let saveAction = UIAlertAction(title: "Save",
                                   style: .default) { action in
                                    let emailField = alert.textFields![0]
                                    let passwordField = alert.textFields![1]
                                  
                                    FIRAuth.auth()!.createUser(withEmail: emailField.text!,
                                                               password: passwordField.text!) { user, error in
                                                                if error == nil {
                                                                  FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                                                                                         password: self.textFieldLoginPassword.text!)
                                                                }
                                    }
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addTextField { textEmail in
      textEmail.placeholder = "Enter your email"
    }
    
    alert.addTextField { textPassword in
      textPassword.isSecureTextEntry = true
      textPassword.placeholder = "Enter your password"
    }
    
    alert.addAction(cancelAction)
    alert.addAction(saveAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == textFieldLoginEmail {
      textFieldLoginPassword.becomeFirstResponder()
    }
    if textField == textFieldLoginPassword {
      textField.resignFirstResponder()
    }
    return true
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

