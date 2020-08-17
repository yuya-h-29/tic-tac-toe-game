//
//  LoginViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(image: K.Image.backgroundFruitsTop)

        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    
    
    //MARK: - Login with existing account

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = emailTextFeild.text, let password = passwordTextFeild.text {
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
              
                
                if error != nil {
                    
                    // display alert message when the user failed to sign in
                    
                    let alert = UIAlertController(title: "Login failed", message: "Sorry. \(error!.localizedDescription)", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    self!.present(alert, animated: true, completion: nil)
                
                    
                } else {
                    
                    self!.performSegue(withIdentifier: K.loginToHome, sender: self)
                    
                }
                
              
            }
            
        }
        

        

        
        
    }
    
}
