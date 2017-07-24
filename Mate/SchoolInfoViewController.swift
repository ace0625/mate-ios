//
//  SchoolInfoViewController.swift
//  Mate
//
//  Created by Dan Kim on 7/24/17.
//  Copyright © 2017 Dan Kim. All rights reserved.
//

import UIKit

class SchoolInfoViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var textFieldSchool: UITextField!
    @IBOutlet weak var textFieldMajor: UITextField!
    @IBOutlet weak var textFieldStudentId: UITextField!
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
        
        self.textFieldSchool.layer.backgroundColor = UIColor.white.cgColor
        self.textFieldSchool.layer.masksToBounds = false
        self.textFieldSchool.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
        self.textFieldSchool.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.textFieldSchool.layer.shadowOpacity = 1.0
        self.textFieldSchool.layer.shadowRadius = 0.0
        
        self.textFieldMajor.layer.backgroundColor = UIColor.white.cgColor
        self.textFieldMajor.layer.masksToBounds = false
        self.textFieldMajor.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
        self.textFieldMajor.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.textFieldMajor.layer.shadowOpacity = 1.0
        self.textFieldMajor.layer.shadowRadius = 0.0
        
        self.textFieldStudentId.layer.backgroundColor = UIColor.white.cgColor
        self.textFieldStudentId.layer.masksToBounds = false
        self.textFieldStudentId.layer.shadowColor = UIColor(hexString: "#eeeeee")?.cgColor
        self.textFieldStudentId.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.textFieldStudentId.layer.shadowOpacity = 1.0
        self.textFieldStudentId.layer.shadowRadius = 0.0
        
        self.nextButton.layer.cornerRadius = 4
        self.nextButton.layer.shadowColor = UIColor(hexString: "#3fa5a5a5")?.cgColor
        self.nextButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.nextButton.layer.shadowOpacity = 0.1
    }
    
    // MARK: Actions
    
    @IBAction func nextButtonPressed(_ sender: Any) {
    }
}
