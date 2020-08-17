//
//  CustomButton.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/17.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    func setupButton() {
        setShadow()
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 25
    }
    
    
    private func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
