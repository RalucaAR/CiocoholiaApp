//
//  OrdersViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 29/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var orders: [OrderModel] = []
    

    @IBOutlet weak var ordersTableView: UITableView!
    @IBAction func logoutAction(_ sender: Any) {
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
        self.ordersTableView.delegate = self
        self.ordersTableView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllUserOrders { (success) in
            if success {
                DispatchQueue.main.async {
                   self.ordersTableView.reloadData()
                   
            }
        }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrdersViewCell


        let order = orders[indexPath.row]
        
            
        cell.orderName.text = order.name ?? "Order"
        cell.orderTotal.text = "\(String(describing: order.total!)) lei" 
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 80.0
       }
    
    func getAllUserOrders(success: @escaping (Bool) -> Void) {
        let ref  = Firestore.firestore().collection(CollectionPaths.users)
        ref.getDocuments { (snapshot, error) in
            if error != nil {
                print("Error at admin orders retrieving!")
            }
            else {
                for document in snapshot!.documents{
                    self.getOrders(id: document.documentID) { (success) in
                        if success {
                            self.ordersTableView.reloadData()
                        }
                    }
                }
                success(true)
            }
        }
    }
    
    func getOrders(id: String, success: @escaping (Bool) -> Void) {
        let ref  = Firestore.firestore().collection(CollectionPaths.users).document(id).collection(CollectionPaths.orders)
        ref.getDocuments() {
           (snapshot, err) in
           if err != nil {
               print("Error getting document data!")
           }
           else{
            var currentOrders: [OrderModel] = []
            for document in snapshot!.documents {
                let order = OrderModel()
                order.name = document.documentID
                order.total = document["total"] as? Double
               // let quantity = document["quantity"] as! Double
                currentOrders.append(order)
            }
            self.orders = currentOrders
             success(true)
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
