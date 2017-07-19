//
//  EmailLoginViewController.swift
//  Mate
//
//  Created by Dan Kim on 7/3/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit
import FirebaseAuth

class EmailLoginViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: Constants
  let loginToList = "LoginToList"
  let loginToSignUp = "LoginToSignUp"
  
  // MARK: Properties
  var isValidEmail: Bool = false
  var isValidPassword: Bool = false
  
  // MARK: Outlets
  @IBOutlet weak var textFieldLoginEmail: UITextField!
  @IBOutlet weak var textFieldLoginPassword: UITextField!
  @IBOutlet var emailLogInButton: UIButton!
  @IBOutlet var signUpContainerView: UIView!
  @IBOutlet weak var bottomLayoutGuideConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    try! Auth.auth().signOut()
    Auth.auth().addStateDidChangeListener() { auth, user in
      if user != nil {
        self.performSegue(withIdentifier: self.loginToList, sender: nil)
      }
    }
    
    self.setUpView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    let navVc = segue.destination as! UINavigationController
    let roomListVc = navVc.viewControllers.first as! RoomListTableViewController
    
    roomListVc.senderDisplayName = textFieldLoginEmail?.text
  }
  
  
  // MARK: Functions
  
  func setUpView() {
    self.textFieldLoginEmail.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldLoginEmail.layer.masksToBounds = false
    self.textFieldLoginEmail.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldLoginEmail.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldLoginEmail.layer.shadowOpacity = 1.0
    self.textFieldLoginEmail.layer.shadowRadius = 0.0
    
    self.textFieldLoginPassword.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldLoginPassword.layer.masksToBounds = false
    self.textFieldLoginPassword.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldLoginPassword.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldLoginPassword.layer.shadowOpacity = 1.0
    self.textFieldLoginPassword.layer.shadowRadius = 0.0
    
    self.emailLogInButton.layer.cornerRadius = 4
    self.emailLogInButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
    self.emailLogInButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.emailLogInButton.layer.shadowOpacity = 0.1
    
    self.signUpContainerView.layer.borderColor = UIColor(hexString: "#e8e8e8")?.cgColor
    self.signUpContainerView.layer.borderWidth = 1.0
  }
  
  /*
   Check valid email address according to the designated rules.
   */
  func checkValidEmailAddress(_ emailAddress: NSString) -> Bool {
    let filterString = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    let emailTest = NSPredicate.init(format: "SELF MATCHES %@", filterString)
    return emailTest.evaluate(with:emailAddress)
  }
  
  /*
   Check valid pasword according to the designated rules.
 */
  func checkValidPassword(_ password: NSString) -> Bool {
//    let filterString = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d^a-zA-Z0-9].{5,19}$"
//    let passwordTest = NSPredicate.init(format: "SELF MATCHES %@", filterString)
    if password.length > 5 {
      return true
    } else {
      return false
    }
//    return passwordTest.evaluate(with:password)
  }
  
  // MARK: Actions
  
  @IBAction func loginAction(_ sender: Any) {
    Auth.auth().signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!, completion: nil)
  }
  
  @IBAction func signUpAction(_ sender: Any) {
    self.performSegue(withIdentifier: self.loginToSignUp, sender: nil)
//    let alert = UIAlertController(title: "Register",
//                                  message: "Register",
//                                  preferredStyle: .alert)
//    
//    let saveAction = UIAlertAction(title: "Save",
//                                   style: .default) { action in
//                                    let emailField = alert.textFields![0]
//                                    let passwordField = alert.textFields![1]
//                                    
//                                    Auth.auth().createUser(withEmail: emailField.text!,
//                                                           password: passwordField.text!) { user, error in
//                                                            if error == nil {
//                                                              Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!,
//                                                                                 password: self.textFieldLoginPassword.text!)
//                                                            }
//                                    }
//    }
//    
//    let cancelAction = UIAlertAction(title: "Cancel",
//                                     style: .default)
//    
//    alert.addTextField { textEmail in
//      textEmail.placeholder = "Enter your email"
//    }
//    
//    alert.addTextField { textPassword in
//      textPassword.isSecureTextEntry = true
//      textPassword.placeholder = "Enter your password"
//    }
//    
//    alert.addAction(cancelAction)
//    alert.addAction(saveAction)
//    
//    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func findEmailOrPassword(_ sender: Any) {
  }
  
  @IBAction func backButtonAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Notifications
  
  func keyboardWillShowNotification(_ notification: Notification) {
    let keyboardEndFrame = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
    bottomLayoutGuideConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
    self.view.layoutIfNeeded()
  }
  
  func keyboardWillHideNotification(_ notification: Notification) {
    bottomLayoutGuideConstraint.constant = self.view.frame.height / 4
    self.view.layoutIfNeeded()
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
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    if textField == self.textFieldLoginEmail {
      if self.checkValidEmailAddress(self.textFieldLoginEmail.text! as NSString) {
        self.isValidEmail = true
      } else {
        self.isValidEmail = false
      }
      
    } else if textField == self.textFieldLoginPassword {
      if self.checkValidPassword(self.textFieldLoginPassword.text! as NSString) {
        self.isValidPassword = true
      } else {
        self.isValidPassword = false
      }
    }
    
    if self.isValidEmail && self.isValidPassword {
      self.emailLogInButton.isUserInteractionEnabled = true
      self.emailLogInButton.backgroundColor = UIColor(hexString: "#0c59f2")
    } else {
      self.emailLogInButton.isUserInteractionEnabled = false
      self.emailLogInButton.backgroundColor = UIColor(hexString: "#aaaaaa")
    }
    
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}
