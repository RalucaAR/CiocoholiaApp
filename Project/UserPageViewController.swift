//
//  UserPageViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 12/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class UserPageViewController: UIViewController {

    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.setIsLoggedIn(value: false)
        // show login page
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(loginPage, animated: true, completion: nil)
    }
    @IBOutlet weak var username: UILabel!
    var usernameString: String?
    var passwordString: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        username.text = usernameString
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
