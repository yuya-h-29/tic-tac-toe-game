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
    
    let db = Firestore.firestore()
    
    // user (player) realted
    var playerDocumentId = ""
    var players: [Player] = []
    var player = Player(uID: "", name: "", isReady: false, email: "")
    var playerInfo = [String: Any]()
    let user = Auth.auth().currentUser
    
    // game related
    var gameDocumentID = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(image: K.Image.backgroundImage)
        title = K.Names.title
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        
        getUserDocumetId()
        loadActivePlayers()
    }
    
    
    //MARK: - load active players on table
    
    // get players who is ready to play
    func loadActivePlayers() {
        
        db.collection(K.FStore.playersCollection)
            .whereField(K.FStore.isReadyField, isEqualTo: true)
            .addSnapshotListener { (querySnapshot, err) in
                
                self.players = []
                
                if let err = err {
                    print("Error getting documents1: \(err)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            
                            let data = doc.data()
                            let playerName = data[K.FStore.nameField] as! String
                            let userId = data[K.FStore.uID] as! String
                            let isReady = data[K.FStore.isReadyField] as! Bool
                            let email = data[K.FStore.emailField] as! String
                            let readyPlayer = Player(uID: userId, name: playerName, isReady: isReady, email: email)
                            
                            self.players.append(readyPlayer)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
        }
    }

    
    
    //MARK: - get document ID for the user and pass the value to function(s)
    
    func getUserDocumetId() {
        
        let userAuthUid = db.collection(K.FStore.playersCollection).document(user!.uid)
        
        db.collection(K.FStore.playersCollection)
            .whereField(K.FStore.uID, isEqualTo: userAuthUid.documentID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents2: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
//                        print("\(doc.documentID) => \(doc.data())")
                        self.playerDocumentId = doc.documentID
                        self.registerPlayerName(documentId: self.playerDocumentId)
                        self.playerInfo = doc.data()
                        
                    }
                }
        }
    }
    
    
    
    
    //MARK: - register player name popup
        
    
    // register palyer name
    func registerPlayerName(documentId: String) {
        
        let alert = UIAlertController(title: "Let's register your user name!!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                
                if let textField = alert.textFields?[0], let text = textField.text {
                    self.db.collection(K.FStore.playersCollection)
                    .document(documentId)
                        .updateData([K.FStore.nameField: text]) { err in
                        
                            if let e = err {
                                print("Error updating document when register player name: \(e)")
                            } else {
//                                print("success!")
                                self.playerInfo[K.FStore.nameField] = text
                            }
                    }
                }
            }))
        
            alert.addTextField { (textField) in
                textField.placeholder = "user name"
            }
            self.present(alert, animated: true, completion: nil)
    }
        
    
    
    //MARK: - take player to game room
    // check which room the player check in then take the user to game room
    
    func joinGameRoom (title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: K.homeToGameScreen, sender: self)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("cancel pressed")
        })
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
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
    
    
    //MARK: - create new game room
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        var ref: DocumentReference? = nil
        
        // create NewGame document in firestore
        ref = db.collection(K.FStore.newGameCollection)
            .addDocument(data: [K.FStore.gameBoardField: GameBoard.gameBoard, K.FStore.player1Field: playerInfo[K.FStore.nameField]!, K.FStore.player2Field: K.FStore.player2Field, K.FStore.uID: playerInfo[K.FStore.uID]!]) { (err) in
                
                if let err = err {
                    print("Error getting documents3: \(err)")
                } else {
                    
                    self.gameDocumentID = ref!.documentID
                    
                    self.db.collection(K.FStore.playersCollection).document(self.playerDocumentId).updateData([K.FStore.isReadyField: true]){ err in
                        
                        if let err = err {
                            print("Error updating player's isReady status: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                        
                        //take player to game room
                        self.joinGameRoom(title: K.Messages.makeNewRoom, message: K.Messages.waitOpponent)
                        
                    }
                }
        }
    }
    
    
    
    //MARK: - pass gameDocumentID to GameScreenVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.homeToGameScreen {
            let gameScreenVC = segue.destination as! GameScreenViewController
            
            gameScreenVC.gameDocumentID = gameDocumentID
        }
    }
}





//MARK: - extentions for table view

// populate the table with players
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return players whose status is "isReady"
        return players.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Names.cellIdentifier, for: indexPath)
        cell.textLabel?.text = players[indexPath.row].name
        
        return cell
    }
}



//MARK: - join the active game room

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // serch NewGame db where player1 is ready to play
        
        db.collection(K.FStore.newGameCollection).whereField(K.FStore.uID, isEqualTo: players[indexPath.row].uID).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting game db: \(err)")
            } else {
                
                for doc in querySnapshot!.documents {
//                    print("\(doc.documentID) ====> \(doc.data())")
                    
                    self.gameDocumentID = doc.documentID
                    
                    self.db.collection(K.FStore.newGameCollection).document(self.gameDocumentID).updateData([
                        K.FStore.player2Field: self.playerInfo[K.FStore.nameField]!
                    ]) { err in
                        
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            
                        }

                        // take the player to game room
                        self.joinGameRoom(title: K.Messages.askToJoinTheRoom, message: K.Messages.none)
                    }
                }
            }
        }
    }
}
