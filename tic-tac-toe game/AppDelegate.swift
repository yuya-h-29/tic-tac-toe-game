//
//  AppDelegate.swift
//  tic-tac-toe game
//
//  Created by Yuya Harada on 2020/08/14.
//  Copyright © 2020 Yuya Harada. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        
        
        // setting a screen depending a user is nill or not
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
          
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if user == nil {
                //take user to MenuViewController
                
                let controller = storyboard.instantiateViewController(identifier: K.Controllers.menuVC)
                
                self.window?.rootViewController = controller
                // shows the window and makes it the key window.
                self.window?.makeKeyAndVisible()
                
            } else {
                // take user to HomeViewController
                let controller = storyboard.instantiateViewController(identifier: K.Controllers.HomeVC)
                
                self.window?.rootViewController = controller
                // shows the window and makes it the key window.
                self.window?.makeKeyAndVisible()
            }
            
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

