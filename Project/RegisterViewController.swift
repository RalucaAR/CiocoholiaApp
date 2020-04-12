//
//  RegisterViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 11/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func isValidEmail() -> Bool {

        let regex = try! NSRegularExpression(pattern: "^[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}$",
                    options: [.caseInsensitive])

        return regex.firstMatch(in: self.email.text!, options:[],
                                        range: NSMakeRange(0, email.text!.count)) != nil
    }
    
    func verifyPassword() ->  Bool {
        if passwordTextField.text == confirmPasswordTextField.text {
            return true
        }
        else{
            let passwordValidityAlert = UIAlertController(title: "Invalid password", message: "The two passsords are different!", preferredStyle: UIAlertController.Style.alert)
            passwordValidityAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(passwordValidityAlert, animated: true, completion: nil)
            return false
        }
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
    
    
    
    func validInput() -> Bool {
        if checkIfInputIsEmpty(inputTextField: nameTextField) && checkIfInputIsEmpty(inputTextField: email)
            && checkIfInputIsEmpty(inputTextField: passwordTextField) && checkIfInputIsEmpty(inputTextField: confirmPasswordTextField)
            && verifyPassword() {
            if isValidEmail() {
                return true
            }
            return false
        }
        else{
            return false
        }
    }
    @IBAction func RegisterButton(_ sender: UIButton!) {
      if validInput() {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
            let managedContext = appDelegate.persistentContainer.viewContext
            
            guard let userEntity = NSEntityDescription.entity(forEntityName: "Users", in: managedContext) else { return  }
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(nameTextField.text, forKey: "name")
            user.setValue(email.text, forKey: "email")
            user.setValue(passwordTextField.text, forKey: "password")
            
        do {
                try
                    managedContext.save()
                    print("Created \(user)")
                    let mainTabBar  = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarViewController") as! MainTabBarViewController
                    mainTabBar.username = nameTextField.text
                    mainTabBar.password = passwordTextField.text
                    present(mainTabBar, animated: true, completion: nil)
                    UserDefaults.standard.setIsLoggedIn(value: true)
                
                    
            } catch let error as NSError{
                print ("Could not save. \(error)")
                }
       
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