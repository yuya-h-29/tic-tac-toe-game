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
    var docId = ""
    
    var players: [Player] = []
    var player = Player(playerID: "", name: "", isReady: false)

    let user = Auth.auth().currentUser
    
    
    override func viewWillAppear(_ animated: Bool) {
        getUserDocumetId()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground(image: K.Image.backgroundImage)
        title = K.Names.title
        tableView.delegate = self
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
    }
    
    //MARK: - load players who has an account on the table view

    func loadPlayers() {
    
        db.collection(K.FStore.playersCollection)
            .order(by: K.FStore.dateField, descending: true)
            .whereField(K.FStore.isReadyField, isEqualTo: true)
            .getDocuments() { (querySnapshot, err) in
            
            self.players = []
            
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        
                        let data = doc.data()
                        
                        if let playerName = data[K.FStore.nameField] as? String, let playerID = data[K.FStore.uID] as? String, let isReady = data[K.FStore.isReadyField] as? Bool {
                            let newPlayers = Player(playerID: playerID, name: playerName, isReady:  isReady)
                            self.players.append(newPlayers)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    func getUserDocumetId() {
        let userAuthUid = db.collection(K.FStore.playersCollection).document(user!.uid)
        db.collection(K.FStore.playersCollection)
            .whereField(K.FStore.uID, isEqualTo: userAuthUid.documentID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for doc in querySnapshot!.documents {
                        print("\(doc.documentID) => \(doc.data())")
                        self.docId = doc.documentID
                        
                        self.registerPlayerName(documentId: self.docId)
                    }
                }
        }
    }
    
    
    
    
    //MARK: - register the player name
    
    func registerName() {
        let userData = self.db.collection(K.FStore.playersCollection).document(self.user!.uid)

        self.db.collection(K.FStore.playersCollection)
            .whereField(K.FStore.uID, isEqualTo: userData.documentID)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        
                        let userName = document.data()[K.FStore.nameField] as! String
                    
                        if userName.count < 1 {
                            let alert = UIAlertController(title: "Let's register your user name!!", message: "", preferredStyle: .alert)
                            
                            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                                if let textField = alert.textFields?[0], let text = textField.text {
                                    
                                    self.db.collection(K.FStore.playersCollection)
                                        .document(document.documentID)
                                        .updateData([K.FStore.nameField: text]) { err in
                                        if let e = err {
                                            print("Error updating document: \(e)")
                                        } else {
                                            print("success!")
                                        }
                                    }
                                } 
                            }))
                            alert.addTextField { (textField) in
                                textField.placeholder = "user name"
                                textField.text = userName
                            }
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
        }
    }
    
    
    //MARK: - register palyer name
        
    
    func registerPlayerName(documentId: String) {
        let alert = UIAlertController(title: "Let's register your user name!!", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
                if let textField = alert.textFields?[0], let text = textField.text {
                    self.db.collection(K.FStore.playersCollection)
                    .document(documentId)
                        .updateData([K.FStore.nameField: text]) { err in
                        if let e = err {
                            print("Error updating document: \(e)")
                        } else {
                            print("success!")
                        }
                    }
                }
            }))
            alert.addTextField { (textField) in
                textField.placeholder = "user name"
            }
            self.present(alert, animated: true, completion: nil)
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
    
    
    //MARK: - create new game
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: K.homeToGameScreen, sender: self)
        
//        db.collection(K.FStore.playersCollection)
        
        
        
        
        
    }
    
    

}






//MARK: - extentions for table view


// populate the table with players
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return players.count
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

//        var sender =
//        var receiver =
        
        
        //make new db and
        
        
        db.collection(K.FStore.newGameCpllection)
            .addDocument(data: [K.FStore.gameBoardField: GameBoard.gameBoard]) { (err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                }
        }
        
        
        
        
        
        performSegue(withIdentifier: K.homeToGameScreen, sender: self)
    }
}
