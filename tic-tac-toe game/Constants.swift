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
    
    struct Messages {
        static let askToJoinTheRoom = "Do you want to play the game in this game room?"
        static let none = ""
        static let makeNewRoom = "Do you want to make a new game room?"
        static let waitOpponent = "Please wait until another player is ready."
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
        static let GameVC = "GameScreenViewController"
    }
    
    
    struct FStore {
        static let playersCollection = "Players"
        static let newGameCollection = "NewGame"
        static let emailField = "email"
        static let nameField = "name"
        static let uID = "uID"
        static let dateField = "date"
        static let isReadyField = "isReady"
        static let player1Field = "player1"
        static let player2Field = "player2"
        static let gameBoardField = "gameBoard"
        static let isPlayer1Turn = "isPlayer1"
        static let isGameOver = "isGameOver"
        static let result = "result"
    }
}
