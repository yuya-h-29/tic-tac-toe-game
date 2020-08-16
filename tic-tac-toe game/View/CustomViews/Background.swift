//
//  Background.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/16.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import Foundation
import UIKit

struct Background {
    
    static func setBackground () {

        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: K.Image.backgroundImage)
        backgroundImage.contentMode = .scaleAspectFill

        
        
//        view.addSubview(backgroundImage)
//        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
//        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//
//        view.sendSubviewToBack(backgroundImage)
    }
}
