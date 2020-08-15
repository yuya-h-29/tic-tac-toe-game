//
//  SignUpViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    


    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    
    
    //MARK: - register a new account
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                
                if error != nil {
                    
                    // make a pop up when a user failed to login
                    
                    let invalidEmail = UIAlertController(title: "Register failed", message: "Sorry, we were not able to make your account. Please use a valid email adress.", preferredStyle: .alert)
                    
                    let shortPassword = UIAlertController(title: "Register failed", message: "Sorry, the password must have at least 6 characters.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    
                    
                    // display alert
                    
                    if password.count < 6 {
                        shortPassword.addAction(action)
                        self.present(shortPassword, animated: true, completion: nil)
                        
                    } else {
                        invalidEmail.addAction(action)
                        self.present(invalidEmail, animated: true, completion: nil)
                    }
                    
                    
                } else {
                    
                    self.performSegue(withIdentifier: K.registerToHome, sender: self)
                    
                }
                
            }
            
        }
    }
    


}
