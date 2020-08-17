//
//  Constants.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import Foundation

struct K {
    
    // sugue
    static let menuToLogin = "menuToLogin"
    static let menuToRegister = "menuToRegister"
    static let loginToHome = "loginToHome"
    static let registerToHome = "registerToHome"
    static let homeToGameScreen = "homeToGameScreen"
    
    
    struct Names {
        static let title = "Apple VS Pineapple"
        static let cellIdentifier = "playerCell"
    }
    
    
    struct Image {
        static let backgroundimageWithFruits = "backgroundFruits"
        static let backgroundFruitsTop = "backgroundFruitsTop"
        static let backgroundImage = "backgroundBrown"
        static let plate = "plate"
        static let apple = "apple"
        static let pineapple = "pineapple"
        static let handPoint = "hand.point.right.fill"
    }
    
    
    struct Controllers {
        static let menuVC = "MenuViewController"
        static let HomeVC = "HomeViewController"
    }
    
    
    struct FStore {
        static let playersCollection = "Players"
        static let emailField = "email"
        static let nameField = "name"
    }
}
