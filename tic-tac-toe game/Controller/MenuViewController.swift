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
        setBackground(image: K.Image.backgroundimageWithFruits)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.menuToLogin, sender: self)
    }
    
    

    @IBAction func signUpPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.menuToRegister, sender: self)
    }
    

}


extension UIViewController {
    
    
    
    func setBackground (image:
    String) {
        
        let backgroundImageView = UIImageView()
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        backgroundImageView.image = UIImage(named: image)
        view.sendSubviewToBack(backgroundImageView)
        
        
    }
    
}
