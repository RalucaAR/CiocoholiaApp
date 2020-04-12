//
//  LoginViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 11/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import CoreData

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
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
            do {
                let results = try managedContext.fetch(fetchRequest)
                for result in results as! [NSManagedObject]{
                    let email = result.value(forKey: "email") as? String
                    let password = result.value(forKey: "password") as? String
                    let name = result.value(forKey: "name") as? String
                    if email == emailAddressTextField.text && password == passwordTextField.text {
                        print("Logged in: \(result)")
                        foundUser = true
                            
                        // prepare the next screen
                        let mainTabBar  = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                        mainTabBar.username = name
                        mainTabBar.password = password
                        present(mainTabBar, animated: true, completion: nil)
                        
                        // set UserDefaults
                        UserDefaults.standard.setIsLoggedIn(value: true)
                        
                    }
                }
                if (!foundUser) {
                    let invalidInputAlert = UIAlertController(title: "Incorrect credentials", message: "Incorrect email or password!", preferredStyle: UIAlertController.Style.alert)
                    invalidInputAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(invalidInputAlert, animated: true, completion: nil)
                }
            }catch let error as NSError {
                print ("\(error)")
            }
        }
        
    }

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        if (segue.identifier == "toUserPage")
        {
            let nextScene = segue.destination as! UserPageViewController
            nextScene.username.text = self.username
        }
    } */
    

}
