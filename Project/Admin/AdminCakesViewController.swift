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
import FirebaseFirestore

class AdminCakesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var products: [ProductModel] = []
    var productToDeleteUID: String = ""
    var indicator:ProgressIndicator?
    
    @IBOutlet weak var productTableView: UITableView!
    @IBAction func addNewProductTapped(_ sender: Any) {
        let addNewPage  = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        addNewPage.modalPresentationStyle = .fullScreen
        self.present(addNewPage, animated: true, completion: nil)
    }
    
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
   
    
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Loading products...")
        self.view.addSubview(indicator!)
        self.productTableView.delegate = self
        self.productTableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
            self.getProducts() { (success) in
            if success {
                DispatchQueue.main.async {
                    self.productTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminProductCell", for: indexPath) as! AdminProductTableViewCell


        let product = products[indexPath.row]
        
        ImageLoader.image(for:  NSURL(string: product.image ?? "")! as URL) { (image) in
                       cell.productImage.image = image
        }
            
        cell.productNameLabel.text = product.name
        cell.productPriceLabel.text = product.price
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteProduct(productToDelete: self.products[indexPath.row].name!) { (true) in
                tableView.beginUpdates()
                let deletedData = self.products[indexPath.row].name!
                print ("Deleted: " + deletedData)
                self.products.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.endUpdates()
                self.productTableView.reloadData()
            }
            
        }
    }
    
    
    func getProductToDelete(productName: String, productToDeleteSucces: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection(CollectionPaths.cakes)
          ref.getDocuments() { (snapshot, error) in
              if error != nil {
                  print("Error at reading current location!")
              }
              else {
                  for document in snapshot!.documents {
                      let name = document["name"] as? String
                      if name == productName {
                          self.productToDeleteUID = document.documentID
                          productToDeleteSucces(true)
                      }
                  }
              }
              
          }
      }
      
      func deleteProduct(productToDelete: String, deletionSuccess: @escaping(Bool) -> Void) {
          getProductToDelete(productName: productToDelete) { (true) in
              let ref = Firestore.firestore().collection(CollectionPaths.cakes)
              ref.document(self.productToDeleteUID).delete();
              deletionSuccess(true)
          }
          
      }
      
    func getProducts(success: @escaping (Bool) -> Void){
        indicator!.start()
          let ref = Firestore.firestore().collection(CollectionPaths.cakes)
          ref.getDocuments() { (snapshot, error) in
              if error != nil {
                  print("Error at admin product reading!")
              }
              else {
                  var foundProducts: [ProductModel] = []
                  for document in snapshot!.documents {
                    self.indicator!.stop()
                      let product = ProductModel()
                          product.name = document["name"] as? String
                          product.description = document["description"] as? String
                          product.price = document["price"] as? String
                          product.image = document["image"] as? String
                          product.category = document["category"] as? String
                          foundProducts.append(product)
                    
                    }
                    self.products = foundProducts
                    success(true)
                }
          }
      }
      
    
      // MARK: - Navigation

      // In a storyboard-based application, you will often want to do a little preparation before navigation
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "toProductEditDetail" {
              let destinationPage = segue.destination as! EditProductViewController
              let cell = sender as! UITableViewCell
              let index = self.productTableView.indexPath(for: cell)
              destinationPage.title = self.products[index!.row].name
              destinationPage.product = self.products[index!.row]
          }
      }

}
