//
//  LoginViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 11/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
//import CoreData
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController {
    
    var foundUser: Bool = false


    @IBAction func signUp(_ sender: Any) {
    }
    func checkIfInputIsEmpty(inputTextField: UITextField) -> Bool {
        guard let inputText = inputTextField.text, !inputText.isEmpty else {
            let emptyInputAlert = UIAlertController(title: "Empty \(inputTextField.placeholder ?? "input")", message: "No input provided for \(inputTextField.placeholder ?? "")!", preferredStyle: UIAlertController.Style.alert)
            emptyInputAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(emptyInputAlert, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    @IBAction func continueButton(_ sender: Any) {
        if checkIfInputIsEmpty(inputTextField: emailAddressTextField) , checkIfInputIsEmpty(inputTextField: passwordTextField) {
            // Firebase
            Auth.auth().signIn(withEmail: emailAddressTextField.text!, password: passwordTextField.text!) { (result, error) in
                if error == nil {
                    print("Logged in user: \(self.emailAddressTextField.text!)")
                        
                    let userUid = Auth.auth().currentUser!.uid
                    let ref = Firestore.firestore().collection(CollectionPaths.users)
                    _ = ref.whereField("uid", isEqualTo: userUid).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                let document = querySnapshot!.documents.first
                                let isAdmin = document?["isAdmin"] as! Bool
                                if isAdmin == true{
                                   let adminPage  = self.storyboard?.instantiateViewController(withIdentifier: "AdminTabBarViewController") as! AdminTabBarViewController
                                    adminPage.modalPresentationStyle = .fullScreen
                                    self.present(adminPage, animated: true, completion: nil)
                                }
                                else{
                                    let mainTabBar  = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                                    mainTabBar.modalPresentationStyle = .fullScreen
                                    self.present(mainTabBar, animated: true, completion: nil)
                                }
                                
                    }
                    }
                    
                    // set UserDefaults
                    UserDefaults.standard.setIsLoggedIn(value: true)
                    UserDefaults.standard.setLoggedInUserEmail(value: self.emailAddressTextField.text!)
                }
                else {
                    let invalidInputAlert = UIAlertController(title: "Incorrect credentials", message: "Incorrect email or password!", preferredStyle: UIAlertController.Style.alert)
                    invalidInputAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(invalidInputAlert, animated: true, completion: nil)
                    print(error?.localizedDescription ?? "Error loggin user!")
                }
            }
        }
        
    }

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
