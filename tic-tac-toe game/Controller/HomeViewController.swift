//
//  HomeViewController.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/15.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var players: [Player] = [
        Player(account: "2@d.com", name: "Jiro", loginNow: true),
        Player(account: "3@r.com", name: "Taro", loginNow: true),
        Player(account: "3f@c.com", name: "Saburo", loginNow: false),
        Player(account: "3f@c.com", name: "Saburo", loginNow: false)

    ]
    
    
    var activePlayers = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        numOfActivePlayers()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        
        title = K.Names.title
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true

      
    }
    
    
    
    //MARK: - logout action
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        
        do {
            try Auth.auth()
                .signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            
            
            // show pop up when logout failed
            
            let alert = UIAlertController(title: "Logout failed", message: signOutError as? String, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    //MARK: - count players who are logged in
    
    func numOfActivePlayers() {
        for player in players {
            if player.loginNow == true {
                activePlayers += 1
            }
        }
    }
    

}


//MARK: - extentions for table view


// populate the table with players
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return activePlayers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Names.cellIdentifier, for: indexPath)
        cell.textLabel?.text = players[indexPath.row].name
        
        return cell
        
    }
}


extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
