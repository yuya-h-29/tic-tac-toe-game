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
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(image: K.Image.backgroundFruitsTop)
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    
    
    
    //MARK: - register a new account
    
    @IBAction func registerPressed(_ sender: UIButton) {

        if let email = emailTextField.text, let password = passwordTextField.text {
            
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                
                
                if error != nil {
                    
                    // display a pop up alert when a user failed to register a new account
                    
                    let invalidEmail = UIAlertController(title: "Register failed", message: "Sorry, we were not able to make your account. Please use a valid email adress and try again.", preferredStyle: .alert)
                    
                    let shortPassword = UIAlertController(title: "Register failed", message: "Sorry, the password must have at least 6 characters. Please make sure the password length.", preferredStyle: .alert)
                    
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    }
                    
                    
                    if password.count < 6 {
                        shortPassword.addAction(action)
                        self.present(shortPassword, animated: true, completion: nil)
                        
                    } else {
                        
                        invalidEmail.addAction(action)
                        self.present(invalidEmail, animated: true, completion: nil)
                    }
                    
                    
                } else {
                    
    
                    // Add a new document with a generated ID
                    var ref: DocumentReference? = nil
                    
                    ref = self.db.collection(K.FStore.playersCollection).addDocument(data: [
                        K.FStore.emailField: email,
                        K.FStore.nameField: "",
                        K.FStore.uID: Auth.auth().currentUser!.uid,
                        K.FStore.dateField: Date().timeIntervalSince1970
                    ]) { (error) in
                        
                        if let err = error {
                            print("There was an issue storing data to firestore. \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            print("this is your uid: \(String(describing: Auth.auth().currentUser!.uid))")
                            self.performSegue(withIdentifier: K.registerToHome, sender: self)
                        }
                    }
                    
                    
                }
                
            }
            
        }
    }
}


extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
