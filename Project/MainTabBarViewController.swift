//
//  MainTabBarViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 12/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    var username: String?
    var password: String?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        guard let viewControllers = viewControllers else{ return }
        /*for viewController in viewControllers {
            if let profileNavController = viewController as? ProfileNavigationController{
                if let userPage = profileNavController.viewControllers.first as? UserPageViewController {
                    userPage.usernameString = username
                    
                }
            }
           
        } */
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
