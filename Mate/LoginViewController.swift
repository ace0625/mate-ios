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
  @IBOutlet weak var pageView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var facebookLogInButton: UIButton!
  @IBOutlet weak var kakaoLogInButton: UIButton!
  
  var userEmail: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    try! Auth.auth().signOut()
    Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "roomList") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = mainController
      }
    }
    
    self.setUpView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Functions
  
  /*
   Set up UI.
   */
  func setUpView() {
    let colorFrom: UIColor = UIColor(hexString: "#130cb7")!
    let colorTo: UIColor = UIColor(hexString: "#52e5e7")!
    
    let gradientColors: [CGColor] = [colorFrom.cgColor, colorTo.cgColor]
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.colors = gradientColors
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 1, y: 0)
    gradientLayer.frame = self.pageView.bounds
    self.pageView.layer.insertSublayer(gradientLayer, at: 0)
    
    let attrString = NSMutableAttributedString(string: self.titleLabel.text!)
    attrString.addAttribute(NSKernAttributeName, value: 4.4, range: NSMakeRange(0, attrString.length))
    self.titleLabel.attributedText = attrString
    
    self.facebookLogInButton.layer.cornerRadius = 4
    self.facebookLogInButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
    self.facebookLogInButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.facebookLogInButton.layer.shadowOpacity = 0.2
    
    self.kakaoLogInButton.layer.cornerRadius = 4
    self.kakaoLogInButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
    self.kakaoLogInButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.kakaoLogInButton.layer.shadowOpacity = 0.2
  }
  
  /*
   Facebook log in.
   */
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
  
  /*
   Kakao log in.
   */
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
  
  /*
   Fetch data from Facebook.
   */
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
  
  /*
   Firebase log in.
   */
  func signInToFirebase() {
    let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
    Auth.auth().signIn(with: credential, completion: { (user, error) in
      print("Sign in to Firebase")
    })
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
}

