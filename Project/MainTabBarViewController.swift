//
//  MainTabBarViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 12/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    var username: String?
    var password: String?
     var adminExists: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adminExists { (success) in
            if success {
                    self.view.reloadInputViews()
                    }
                }
    }
    
    func adminExists(success: @escaping (Bool) -> Void) {
       
        let databaseRef = Firestore.firestore().collection(CollectionPaths.users)
        databaseRef.getDocuments { (snapshot, error) in
            if error != nil {
                print("Error at admin account creating!")
            } else{
                for document in snapshot!.documents {
                    let currentEmail = document["name"] as? String
                    if currentEmail == "name" {
                        self.adminExists = true
                    }
                }
                success(true)
            }
        }
    }
    
    func checkOrCreateAdminAccount (success: @escaping (Bool) -> Void) {
        
        if adminExists == false {
            Auth.auth().createUser(withEmail: "admin@mail.com", password: "p@rola") { (result, error) in
                if  error != nil {
                    print (error ?? "Erorr creating user")
                }
                else{
                    let db = Firestore.firestore()
                    db.collection(CollectionPaths.users).addDocument(data: ["name" : "admin",
                                                                            "isAdmin": true,
                                                                            "uid": result!.user.uid,
                                                                            "favoritesList": [],
                                                                            "shoppingCartItems": []
                                                                            ])
                    { (error) in
                        if error != nil {
                            print(error ?? "Could not create user!")
                        }
                        else {
                            print("Created admin account!")
                        }
                    }
                    success(true)
                }
            }
        }
        
    }

    override func viewDidAppear(_ animated: Bool) {
        isLoggedInUser()
        
    }
    
    
    func isLoggedInUser() {
        let userState = UserDefaults.standard.getIsLoggedIn()
        if userState {
           
        if UserDefaults.standard.getLoggedInUserEmail() == "admin@mail.com" {
            let adminPage  = self.storyboard?.instantiateViewController(withIdentifier: "AdminTabBarViewController") as! AdminTabBarViewController
            adminPage.modalPresentationStyle = .fullScreen
            present(adminPage, animated: true, completion: nil)
        }
        }
        else if userState == false {
               // if the user is not logged in, show the login page
                let loginPage  = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginPage.modalPresentationStyle = .fullScreen
            present(loginPage, animated: true, completion: nil)
           }
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
