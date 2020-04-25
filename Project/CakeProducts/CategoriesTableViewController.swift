//
//  CategoriesTableViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 04/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class CategoriesTableViewController: UITableViewController {
    
    var allProducts: [ProductModel] = []
    var categoryProducts: [ProductModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategoryProducts()
        self.tableView.backgroundColor = UIColor.black
    }

        
    func getProducts(success: @escaping (Bool) -> Void){
        let ref = Firestore.firestore().collection(CollectionPaths.cakes)
        ref.getDocuments() {
            (querySnapshot, err) in
            if err != nil {
                print("Error getting documents!")
            } else {
                for document in querySnapshot!.documents {
                        let product = ProductModel()
                        product.image = document["image"] as? String
                        product.category = document["category"] as? String
                        product.name   = document["name"] as? String
                        product.price = document["price"] as? String
                        product.description = document["description"] as? String
                        self.allProducts.append(product)
                    }
                }
                success(true)
            }
        
        }
    
    
    func getCategoryProducts(){
        getProducts{ (success) in
        if success {
            for prod in self.allProducts {
                if prod.category == self.title! {
                    self.categoryProducts.append(prod)
                }
            }
            self.tableView.reloadData()
            }
            
        }
    }

        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return productViewModel.levelsList.count
            return categoryProducts.count
        }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell


        let product = categoryProducts[indexPath.row]
        cell.productImage.image = UIImage(named: product.image ?? "")
        cell.productName.text = product.name
        cell.productPrice.text = product.price
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
            return cell
        }
        
       override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100.0
        }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "toProductPage")
               {
                    let nextScene = segue.destination as! ProductViewController
                    let cell = sender as! UITableViewCell
                    let index = self.tableView.indexPath(for: cell)
                    nextScene.title = String(describing: self.categoryProducts[index?.row ?? 0])
                    nextScene.product = self.categoryProducts[index?.row ?? 0]
        }
    }
    

}
