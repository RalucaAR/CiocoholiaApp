//
//  ShoppingCartViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 27/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ShoppingCartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var products: [ShoppingCartItemModel] = []
    var productNames: [ProductModel] = []
    var indicator: ProgressIndicator?
    
    @IBOutlet weak var shoppingCartItems: UITableView!
    @IBOutlet weak var usernameTextField: UILabel!

    @IBAction func loggoutAction(_ sender: Any) {
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
            indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Loading shopping list...")
            self.view.addSubview(indicator!)
            shoppingCartItems.delegate = self
            shoppingCartItems.dataSource = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
        getProductNames{ (successNames) in
            if successNames {

                self.selectCurrentUserShoppingList{ (listSuccess) in
                    if listSuccess {
                        DispatchQueue.main.async {
                            self.shoppingCartItems.reloadData()
                        }
                    }
                    }
                
            }
    }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if products.count == 0 {
            self.shoppingCartItems.setEmptyMessage("Your shopping cart is empty!😢")
        }
        else
        {
            self.shoppingCartItems.restore()
            
        }
        return products.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingCartCell", for: indexPath) as! ShoppingCartTableViewCell


          let product = products[indexPath.row]
          
        ImageLoader.image(for:  NSURL(string: product.product!.image!)! as URL) { (image) in
                         cell.productImage.image = image
          }
              
         cell.productName.text = product.product!.name
         cell.productPrice.text = product.product!.price
        //  cell.productQuantity.text =
       // cell.stepperObj.value = Double(Int(product.quantity))
          cell.layer.cornerRadius = 10
          cell.layer.masksToBounds = true
          cell.layer.borderColor = UIColor.black.cgColor
          cell.layer.borderWidth = 3
          
              return cell
      }
    
    func getProductNames(success: @escaping (Bool) -> Void) {
        indicator!.start()
        let ref  = Firestore.firestore().collection(CollectionPaths.cakes)
               ref.getDocuments() {
                  (snapshot, err) in
                  if err != nil {
                      print("Error getting document data!")
                  }
                  else{
                    var currentList: [ProductModel] = []
                    for document in snapshot!.documents {
                       let cake = ProductModel()
                        cake.description = document["description"] as? String
                        cake.price = document["price"] as? String
                        cake.image = document["image"] as? String
                        cake.category = document["category"] as? String
                        cake.name = document["name"] as? String
                        currentList.append(cake)
                        }
                    self.productNames = currentList
                    success(true)
                }
        }
    }
    
    func getShoppingListById (id: String, successShoppingList: @escaping (Bool) -> Void) {

            let currentRef = Firestore.firestore().collection(CollectionPaths.users).document(id).collection(CollectionPaths.shoppingCartItems)
            currentRef.getDocuments() { (cartSnapshot, cartErr) in
            if cartErr != nil {
                print("Error getting document data!")
            }
            else{
                var currentShoppingList: [ShoppingCartItemModel] = []
                for document in cartSnapshot!.documents {
                    for prod in self.productNames {
                        let cake = document.documentID
                        if  cake == prod.name {
                            let product = ShoppingCartItemModel()
                            product.product?.name = document.documentID
                             product.product?.description = prod.description
                             product.product?.price = prod.price
                             product.product?.image = prod.image
                            product.quantity = document.get("quantity") as! String
                            currentShoppingList.append(product)
                        }
                    }
                }
                self.products = currentShoppingList
                successShoppingList(true)
            }
            
        }
    }
      
    func selectCurrentUserShoppingList(success: @escaping (Bool) -> Void) {
        guard let currentUser = Auth.auth().currentUser?.uid else { return}
       let ref  = Firestore.firestore().collection(CollectionPaths.users).whereField("uid", isEqualTo: currentUser)
       
       ref.getDocuments() {
          (snapshot, err) in
          if err != nil {
              print("Error getting document data!")
          }
          else{
              let document = snapshot!.documents.first
              self.getShoppingListById(id: document!.documentID) { (shopSuccess) in
                if shopSuccess {
                  let name  = document?["name"] as! String
                  self.usernameTextField.text =  "Welcome, " + name
                  self.indicator!.stop()
                      
                }
                success(true)
            }
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

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .orange
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 17)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
