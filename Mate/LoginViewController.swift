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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Actions
  @IBAction func facebookLoginAction(_ sender: Any) {
    self.facebookLogin()
  }
  
  @IBAction func kakaoLoginAction(_ sender: Any) {
    self.kakaoLogin()
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
  
  func kakaoLogin() {
    let session: KOSession = KOSession.shared();
    if session.isOpen() {
      session.close()
    }

    session.presentingViewController = self
    session.open(completionHandler: { (error) in
      if error != nil {
        print("Kakao login error: \(error?.localizedDescription ?? "")")
      } else if session.isOpen() == true {
        print("kakao in")
        KOSessionTask.meTask(completionHandler: { (result, error) in
          if result != nil {
            
            print("login success: \(KOSession.shared().accessToken)")
            
            DispatchQueue.main.async(execute: { () -> Void in
              let kakao: KOUser = result as! KOUser
              
              if let nickName = kakao.email {
                print("kakao email: \(nickName)")
              }
              if let image = kakao.property(forKey: KOUserProfileImagePropertyKey) as? String {
                print("kakao email: \(image)")
              }
              if let thumbnail = kakao.property(forKey: KOUserThumbnailImagePropertyKey) as? String {
                print("kakao thumbnail: \(thumbnail)")
              }
              if let age = kakao.properties?["age"] {
                print("kakao age: \(age)")
              }
            })
          }
        })
      }
    }, authParams: nil, authTypes: [NSNumber(value: KOAuthType.talk.rawValue), NSNumber(value: KOAuthType.account.rawValue), NSNumber(value: KOAuthType.story.rawValue)])
  }
  
  func getFBUserData() {
    if FBSDKAccessToken.current() != nil {
      FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
        if error == nil {
          print(result as Any)
          let data: [String: AnyObject] = result as! [String: AnyObject]
          self.userEmail = data["email"] as? String
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
