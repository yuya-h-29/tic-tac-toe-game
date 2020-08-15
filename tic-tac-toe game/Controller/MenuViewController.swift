//
//  MenuViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.menuToLogin, sender: self)
    }
    
    

    @IBAction func signUpPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.menuToRegister, sender: self)
    }
    

}
