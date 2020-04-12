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
        //isLoggedInUser()
        
        // Do any additional setup after loading the view.
        
        guard let viewControllers = viewControllers else{ return }
        for viewController in viewControllers {
            if let profileNavController = viewController as? ProfileNavigationController{
                if let userPage = profileNavController.viewControllers.first as? UserPageViewController {
                    userPage.usernameString = username
                    userPage.passwordString = password
                    
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        isLoggedInUser()
    }
    
    
    func isLoggedInUser() {
           let userState = UserDefaults.standard.getIsLoggedIn()
           
           if userState == false {
               // if the user is not logged in, show the login page
                let loginPage  = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
