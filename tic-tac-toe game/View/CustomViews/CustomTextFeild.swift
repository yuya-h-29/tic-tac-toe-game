//
//  Custom.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/18.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextFeild()
    }
    
    
    private func setupTextFeild() {

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
        textColor = .black
        backgroundColor = UIColor(white: 1.0, alpha: 0.85)
        autocorrectionType = .no
        
    }

}
