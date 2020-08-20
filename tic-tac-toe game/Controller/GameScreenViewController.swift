//
//  GameScreenViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

/*
 currently, this game is single play...
 */



import UIKit
import Firebase

class GameScreenViewController: UIViewController {

    
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var playerOneHand: UIImageView!
    @IBOutlet weak var playerTwoHand: UIImageView!
    @IBOutlet weak var player1: UILabel!
    @IBOutlet weak var player2: UILabel!
    
    var isPlayer1 = true
    var isGameOver = false
    var gameDocumentID = ""
    var player1UID = ""
    
    let db = Firestore.firestore()
    var playerID = ""
    

    /* gameBoard structure
     
     | 0 | 1 | 2 |
     -------------
     | 3 | 4 | 5 |
     -------------
     | 6 | 7 | 8 |
     
     */
    
//    var gameBoard: [String] = [
//        "", "", "", "", "", "", "", "", "",
//    ]
    
    var gameBoard: [String] = GameBoard.gameBoard
    
    
    
    let winningPatterns = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6],
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(image: K.Image.backgroundImage)
        result.text = ""
        
        displayHandPointer()
        loadGameInfo()
        getSignedinPlayerID()
    }
    
    
    //MARK: - load player data
    // display player names on the game and add fields on gameDocument
    
    func loadGameInfo() {
        
        let docRef = db.collection(K.FStore.newGameCollection).document(gameDocumentID)
        
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            //display players name on screen
            self.player1.text = data[K.FStore.player1Field] as? String
            self.player2.text = data[K.FStore.player2Field] as? String
            
            self.player1UID = data[K.FStore.uID] as! String
            
            
            // adding this and see local board game changes
            self.gameBoard = data[K.FStore.gameBoardField] as! [String]
            print("loading game data in loadGame info func: \(self.gameBoard)")
            
        }
        
        // add new fields for match
        docRef.updateData([
            K.FStore.isGameOver: false,
            K.FStore.isPlayer1Turn: true,
            K.FStore.result: ""
            
        ])
    }

    
    
    //MARK: - get user's ID
//    playerID is either player1 or player2 's ID.
//    player1UID is player1's ID.
   
    func getSignedinPlayerID() {
        let user = Auth.auth().currentUser
        if let user = user {
            let userId = user.uid
            playerID = userId
        }
    }

    
    //MARK: - check which player won the game
    
    // 1 - update game board status
    func changeGameBoard (index: Int, fruit: String){
        // add name of the fruit in the gameBoard
        gameBoard[index] = fruit
        
        print("this is the local game board: \(gameBoard)")
    }
    
    
    // 2 - check the game board is one of the winning pattern or not
    func hasGameFinihsed () {
        
        // if one of the player wins, this block is called
        for winningPattern in winningPatterns {
            if gameBoard[winningPattern[0]] == gameBoard[winningPattern[1]] && gameBoard[winningPattern[1]] == gameBoard[winningPattern[2]] && gameBoard[winningPattern[0]].count > 0{
                isGameOver = true
                let winner = isPlayer1 ? player1.text : player2.text
                
                changeMessage(winner: winner)
            }
        }
        // for Draw
        if !gameBoard.contains("") && !isGameOver {
            isGameOver = true
            changeMessage(winner: nil)
        }
    }
    
    
    // 3 - change message if game ends
    
    func changeMessage (winner: String?) {
        
        if winner == nil {
            result.text = "Draw"
        } else {
            result.text = "\(winner!) Won!!"
        }
    }
    


    //MARK: - player's turn related
    
    func displayHandPointer () {
        
        if isGameOver {
            playerOneHand.image = nil
            playerTwoHand.image = nil
            
        } else if isPlayer1 {
            playerTwoHand.image = nil
            playerOneHand.image = UIImage(systemName: K.Image.handPoint)
            
        } else {
            playerOneHand.image = nil
            playerTwoHand.image = UIImage(systemName: K.Image.handPoint)
        }
    }
    
    
    func changePlayerTurn () {
        if isPlayer1 {
            isPlayer1 = false
        } else {
            isPlayer1 = true
        }
    }
     
    
    
    //MARK: - change image of a plate
    
    func changePlateImage (plate: UIButton) {

        let fruitImage = isPlayer1 ? K.Image.apple : K.Image.pineapple

        plate.setImage(UIImage(named: fruitImage), for: .normal)

        changeGameBoard(index: plate.tag, fruit: fruitImage)
    }
    
    
    
    //MARK: - listen the updates ? => need to read the doc more
    
    func listenGameData() {
        
        //listen game data func called
        
        let docRef = db.collection(K.FStore.newGameCollection).document(gameDocumentID)
        
        docRef.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            self.isPlayer1 = data[K.FStore.isPlayer1Turn] as!Bool
            self.gameBoard = data[K.FStore.gameBoardField] as![String]
        }
    }
    
    
    func updateGameData() {
        let docRef = db.collection(K.FStore.newGameCollection).document(gameDocumentID)
        
        print("this will be the new local game board \(gameBoard)")
        docRef.updateData([
            K.FStore.gameBoardField: gameBoard,
            
            K.FStore.isPlayer1Turn: isPlayer1,
        ])
    }

    
    
    
    //MARK: - trigger functions when a plate pressed
    
    @IBAction func platePressed(_ sender: UIButton) {
        
        //MARK: - this is for multy-player?
        
        listenGameData()
        
        
        
        
        
        if gameBoard[sender.tag] == "" && !isGameOver {
            
            
            // check if player is allowed to tap the button
            if (isPlayer1 && playerID == player1UID) || (!isPlayer1 && playerID != player1UID){
                
                changePlateImage(plate: sender)
                hasGameFinihsed()
                changePlayerTurn()
                displayHandPointer()
                // update changes
                updateGameData()
                
            }
        }
    }
}
        
        
