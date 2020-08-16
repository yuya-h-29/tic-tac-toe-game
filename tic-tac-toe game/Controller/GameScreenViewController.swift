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
    @IBOutlet weak var plate1: UIButton!
    @IBOutlet weak var plate2: UIButton!
    @IBOutlet weak var plate3: UIButton!
    @IBOutlet weak var plate4: UIButton!
    @IBOutlet weak var plate5: UIButton!
    @IBOutlet weak var plate6: UIButton!
    @IBOutlet weak var plate7: UIButton!
    @IBOutlet weak var plate8: UIButton!
    @IBOutlet weak var plate9: UIButton!
    
    
    var gameBoard: [String] = [
        
    ]
    
    var isPlayer1 = true
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        result.text = K.Names.title

        isPlayer1Turn()
        // Do any additional setup after loading the view.
    }
    

    
    func isPlayer1Turn () {
        
        if isPlayer1 == true {
            playerTwoHand.image = nil
        } else {
            playerOneHand.image = nil
        }
    }


}
