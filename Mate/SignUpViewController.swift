//
//  SignUpViewController.swift
//  Mate
//
//  Created by Dan Hyunchan Kim on 7/19/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
  
  // MARK: Properties
  @IBOutlet var textFieldEmail: UITextField!
  @IBOutlet var textFieldPassword: UITextField!
  @IBOutlet var textFieldPhoneNumber: UITextField!
  @IBOutlet var textFieldConfirmationNumber: UITextField!
  @IBOutlet var phoneNumberConfirmButton: UIButton!
  @IBOutlet var nextButton: UIButton!
  @IBOutlet var bottomViewContainer: UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUpView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Functions
  
  func setUpView() {
    self.textFieldEmail.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldEmail.layer.masksToBounds = false
    self.textFieldEmail.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldEmail.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldEmail.layer.shadowOpacity = 1.0
    self.textFieldEmail.layer.shadowRadius = 0.0
    
    self.textFieldPassword.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldPassword.layer.masksToBounds = false
    self.textFieldPassword.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldPassword.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldPassword.layer.shadowOpacity = 1.0
    self.textFieldPassword.layer.shadowRadius = 0.0
    
    self.textFieldPhoneNumber.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldPhoneNumber.layer.masksToBounds = false
    self.textFieldPhoneNumber.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldPhoneNumber.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldPhoneNumber.layer.shadowOpacity = 1.0
    self.textFieldPhoneNumber.layer.shadowRadius = 0.0
    
    self.textFieldConfirmationNumber.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldConfirmationNumber.layer.masksToBounds = false
    self.textFieldConfirmationNumber.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldConfirmationNumber.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldConfirmationNumber.layer.shadowOpacity = 1.0
    self.textFieldConfirmationNumber.layer.shadowRadius = 0.0
    
    self.phoneNumberConfirmButton.layer.cornerRadius = 4
    self.phoneNumberConfirmButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
    self.phoneNumberConfirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.phoneNumberConfirmButton.layer.shadowOpacity = 0.1
    
    self.nextButton.layer.cornerRadius = 4
    self.nextButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
    self.nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.nextButton.layer.shadowOpacity = 0.1
    
    self.bottomViewContainer.layer.borderColor = UIColor(hexString: "#e8e8e8")?.cgColor
    self.bottomViewContainer.layer.borderWidth = 1.0
  }
  
  // MARK: Functions
  
  
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
    let filterString = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d^a-zA-Z0-9].{5,19}$"
    let passwordTest = NSPredicate.init(format: "SELF MATCHES %@", filterString)
    return passwordTest.evaluate(with:password)
  }
  
  // MARK: Actions
  
  @IBAction func backButtonAction(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func phoneNumberConfirmAction(_ sender: Any) {
  }
  
  @IBAction func nextAction(_ sender: Any) {
  }
  
  @IBAction func goToLoginAction(_ sender: Any) {
  }
  
  // MARK: TextField delegate
}
