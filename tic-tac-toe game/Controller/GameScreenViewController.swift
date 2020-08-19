//
//  GameScreenViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

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
    
    var gameBoard: [String] = [
        "", "", "", "", "", "", "", "", "",
    ]
    
    
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
        // Do any additional setup after loading the view.
        loadGameInfo()
        getSignedinPlayerID()
    }
    
    
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
            self.player1.text = data[K.FStore.player1Field] as? String
            self.player2.text = data[K.FStore.player2Field] as? String
            self.player1UID = data[K.FStore.uID] as! String
        }
        
        docRef.updateData([
            K.FStore.isGameOver: false,
            K.FStore.isPlayer1Turn: true,
            K.FStore.result: ""
        
        ])
    }

    
    
    //MARK: - get current user's ID
    
    // playerID is either player1 or player2 's ID.
    // player1UID is player1's ID.
   
    func getSignedinPlayerID() {
        let user = Auth.auth().currentUser
        if let user = user {
            let userId = user.uid
            
            playerID = userId
        }
    }
    
    
    
    
    
    
    //MARK: - check which player won the game
    func changeGameBoard (index: Int, fruit: String){
        
        // add name of the fruit in the gameBoard
        gameBoard[index] = fruit
    }
    
    
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
    

    
    // change message
    
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
    
    
    func chnagePlayerTurn () {
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
    
    
    
    //read data
    
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
            self.isPlayer1 = data[K.FStore.isPlayer1Turn] as!Bool
            self.gameBoard = data[K.FStore.gameBoardField] as![String]
        }
    }
    
    
    func updateGameData() {
        let docRef = db.collection(K.FStore.newGameCollection).document(gameDocumentID)
        
        docRef.updateData([
            K.FStore.gameBoardField: gameBoard,
            K.FStore.isPlayer1Turn: isPlayer1,
            
        
        ])
    }
    
    
    
    
    
    @IBAction func platePressed(_ sender: UIButton) {
        
//        if gameBoard[sender.tag] == "" && !isGameOver{
//
//            changePlateImage(plate: sender)
//            hasGameFinihsed()
//            chnagePlayerTurn()
//            displayHandPointer()
//        }
        
        // if current playerID matches player1UID, enable this button
        if isPlayer1 && playerID == player1UID{
            
            // listen updates
            listenGameData()
            
        print("faaafa\(isPlayer1)")
        
            changePlateImage(plate: sender)
        
        
        
            // update changes
        
            updateGameData()
        
        } else if !isPlayer1 && playerID != player1UID {
            print("\(isPlayer1)")
        }
        
        
        
        
    }
    
    

    
    
}
