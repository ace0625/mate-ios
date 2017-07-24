//
//  BasicInfoViewController.swift
//  Mate
//
//  Created by Dan Kim on 7/21/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit

class BasicInfoViewController: UIViewController {
  
  // MARK: Constants
  let infoStep2 = "InfoStep2"
  
  // MARK: Properties
  
  @IBOutlet weak var navigationBar: UINavigationBar!
  @IBOutlet weak var imageViewProfile: UIImageView!
  @IBOutlet weak var textFieldNickName: UITextField!
  @IBOutlet weak var textFieldBirthDate: UITextField!
  @IBOutlet weak var femaleButton: UIButton!
  @IBOutlet weak var maleButton: UIButton!
  @IBOutlet weak var nextButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.setUpView()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Fuctions
  
  func setUpView() {
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    
    self.imageViewProfile.layer.cornerRadius = self.imageViewProfile.frame.width / 2;
    
    self.textFieldNickName.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldNickName.layer.masksToBounds = false
    self.textFieldNickName.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldNickName.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldNickName.layer.shadowOpacity = 1.0
    self.textFieldNickName.layer.shadowRadius = 0.0
    
    self.textFieldBirthDate.layer.backgroundColor = UIColor.white.cgColor
    self.textFieldBirthDate.layer.masksToBounds = false
    self.textFieldBirthDate.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
    self.textFieldBirthDate.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    self.textFieldBirthDate.layer.shadowOpacity = 1.0
    self.textFieldBirthDate.layer.shadowRadius = 0.0
    
    self.nextButton.layer.cornerRadius = 4
    self.nextButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
    self.nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
    self.nextButton.layer.shadowOpacity = 0.1
  }
  
  // MARK: Actions
  
  @IBAction func cancelAction(_ sender: Any) {
  }
  
  @IBAction func femaleButtonPressed(_ sender: Any) {
  }
  
  @IBAction func maleButtonPressed(_ sender: Any) {
  }
  
  @IBAction func nextButtonPressed(_ sender: Any) {
     self.performSegue(withIdentifier: self.infoStep2, sender: nil)
  }
}
