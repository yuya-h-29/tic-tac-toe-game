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

    
    
    var gameBoard: [String] = [
        
    ]
    
    var isPlayer1 = true
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        result.text = K.Names.title
        displayHandPointer()
        // Do any additional setup after loading the view.
    }
    
    
    
    // when player 1 taped a button, change isPlayer1 to flase

    
    func displayHandPointer () {

        if isPlayer1 == true {
            playerTwoHand.image = nil
            playerOneHand.image = UIImage(systemName: K.Image.handPoint)
        } else {
            playerOneHand.image = nil
            playerTwoHand.image = UIImage(systemName: K.Image.handPoint)
        }
    }
    
    
    
    
    func changePlateImage (plate: UIButton) {

        let fruitImage = isPlayer1 ? K.Image.apple : K.Image.pineapple

        plate.setImage(UIImage(named: fruitImage), for: .normal)

        chnagePlayerTurn()
        displayHandPointer()
    }
    
    
    func chnagePlayerTurn () {
        if isPlayer1 {
            isPlayer1 = false
        } else {
            isPlayer1 = true
        }
    }
    

    
    
    //MARK: - IBA actions for board game
    
    @IBAction func plate1Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    

    @IBAction func plate2Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    
    
    @IBAction func plate3Pressed(_ sender: UIButton) {
        
        changePlateImage(plate: sender)
    }
    
    
    @IBAction func plate4Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    
    
    @IBAction func plate5Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    
    
    @IBAction func plate6Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    

    @IBAction func plate7Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    
    
    @IBAction func plate8Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    
    @IBAction func plate9Pressed(_ sender: UIButton) {
        changePlateImage(plate: sender)
    }
    
    
}
