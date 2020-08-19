//
//  GameScreenViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit

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
        
//        print("this is the gameid "\(gameDocumentID))
    }
    
    // load game data=> palyer name , turn , make fields
    
    
    
    
    
    
    
    
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
    
    
    @IBAction func platePressed(_ sender: UIButton) {
        
        if gameBoard[sender.tag] == "" && !isGameOver{
            
            changePlateImage(plate: sender)
            hasGameFinihsed()
            chnagePlayerTurn()
            displayHandPointer()
        }
    }
    
    

    
    
}
