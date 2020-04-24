//
//  AdminCakesViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 23/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AdminCakesViewController: UIViewController {

    @IBAction func LogoutAction(_ sender: Any) {
        UserDefaults.standard.setIsLoggedIn(value: false)
               UserDefaults.standard.setLoggedInUserEmail(value: "NotLoggedIn")
               
               let firebaseAuth = Auth.auth()
               do {
                 try firebaseAuth.signOut()
               } catch let signOutError as NSError {
                 print ("Error signing out: %@", signOutError)
               }
                 
               
               // show login page
               let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
               present(loginPage, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
