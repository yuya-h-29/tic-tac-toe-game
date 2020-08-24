//
//  GameScreenViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

/* gameBoard structure
 apply tag number like below to each button
 
 | 1 | 2 | 3 |
 -------------
 | 4 | 5 | 6 |
 -------------
 | 7 | 8 | 9 |
 
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
    var playerID = ""
    
    let db = Firestore.firestore()

    var gameBoard: [String] = GameBoard.gameBoard
    var resultMessage = ""
    
    
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
//        result.text = "" -> edit
        addFieldsToGameDocument()
        playerTwoHand.image = nil
        playerOneHand.image = UIImage(systemName: K.Image.handPoint)
        
        loadPlayerInfo()
        getSignedinPlayerID()
//        changeImage() -> edit
        listenGameData()
        
    }
    
    
    
    //MARK: - add missing fields for game
    func addFieldsToGameDocument() {
        
        let docRef = db.collection(K.FStore.newGameCollection).document(gameDocumentID)
        
        // add new fields into a current game document
        docRef.updateData([
            K.FStore.isGameOver: false,
            K.FStore.isPlayer1Turn: true,
            K.FStore.result: resultMessage
        ])
    }
    
    
    
    //MARK: - load player information
    // get player's name and display on the screen & get player1UID
    
    func loadPlayerInfo() {
        
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
        }
    }

    
    
    //MARK: - get current user's ID
    // use playerID (current user's ID) for checking it's same as player1 ID or not in platePressed()
    
    func getSignedinPlayerID() {
        let user = Auth.auth().currentUser
        if let user = user {
            let userId = user.uid
            playerID = userId
        }
    }

    
    
    //MARK: - update local game related vlaues
    
    // 1 - update game board status
    func changeGameBoardStatus (index: Int, fruit: String){
        gameBoard[index] = fruit
    }
    
    
    // 2 - check the game board is one of the winning pattern or not
    func hasGameFinihsed () {
        
        // if one of the players wins, this block is called
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
        
        resultMessage = (winner != nil) ? "\(winner!) Won!!": "Draw!!"
        
        DispatchQueue.main.async {
            self.result.text = self.resultMessage
        }
    }
    


    //MARK: - player's turn related
    
    func displayHandPointer () {
        
        if isGameOver {
            
            self.playerOneHand.image = nil
            self.playerTwoHand.image = nil
            
        } else if isPlayer1 {
            
                self.playerTwoHand.image = nil
                self.playerOneHand.image = UIImage(systemName: K.Image.handPoint)

        } else {
            
            self.playerOneHand.image = nil
            self.playerTwoHand.image = UIImage(systemName: K.Image.handPoint)
            
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

        changeGameBoardStatus(index: plate.tag - 1, fruit: fruitImage)
    }
    
    
    
    //MARK: - listen & update game data
    
    // update local game related values
    func listenGameData() {
        
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
            
            let gameBordArr = data[K.FStore.gameBoardField] as! [String]
            for (index, fruit) in gameBordArr.enumerated() {
                if let button =  self.view.viewWithTag(index + 1) as? UIButton {
                    
                    let buttonImage = fruit == "" ? K.Image.plate: fruit
                    
                    DispatchQueue.main.async {
                        button.setImage(UIImage(named: buttonImage), for: .normal)
                    }
                }
            }
            
            self.gameBoard = data[K.FStore.gameBoardField] as! [String]
            self.isPlayer1 = data[K.FStore.isPlayer1Turn] as! Bool
            self.isGameOver = data[K.FStore.isGameOver] as! Bool
            self.displayHandPointer()
            self.result.text = data[K.FStore.result] as? String
        }
    }
    
    
    
    // update Firestore game related values
    func updateGameData() {
        
        let docRef = db.collection(K.FStore.newGameCollection).document(gameDocumentID)
        
        docRef.updateData([
            K.FStore.gameBoardField: gameBoard,
            K.FStore.isPlayer1Turn: isPlayer1,
            K.FStore.isGameOver: isGameOver,
            K.FStore.result: resultMessage
        ])
    }
    
    
    
    // listen & update plate Images
    func changeImage() {
        db.collection(K.FStore.newGameCollection).document(gameDocumentID)
            .addSnapshotListener { documentSnapshot, error in
                if let err = error {
                    print("Error getting documents1: \(err)")
                } else {
                    if let data = documentSnapshot!.data() {
                        
                        let gameBordArr = data[K.FStore.gameBoardField] as! [String]
                        for (index, fruit) in gameBordArr.enumerated() {
                            if let button =  self.view.viewWithTag(index + 1) as? UIButton {
                                
                                let buttonImage = fruit == "" ? K.Image.plate: fruit
                                
                                DispatchQueue.main.async {
                                    button.setImage(UIImage(named: buttonImage), for: .normal)
                                }
                            }
                        }
                    }
                }
        }
    }

    
    
    //MARK: - plate tapped action
    
    @IBAction func platePressed(_ sender: UIButton) {
        
        if gameBoard[sender.tag - 1] == "" && !isGameOver {

            if (isPlayer1 && playerID == player1UID) || (!isPlayer1 && playerID != player1UID){

                changePlateImage(plate: sender)
                hasGameFinihsed()
                changePlayerTurn()
                updateGameData()
            }
        }
    }
}
        
        
