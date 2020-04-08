//
//  CategoriesTableViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 04/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    var products: [ProductModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProducts(productCategory: self.title!)
        self.tableView.backgroundColor = UIColor.black
    }
    
    func getProducts(productCategory :String) {
        _ = URLSession(configuration: .default)
        
        let urlComponents = URLComponents(string: "https://api.jsonbin.io/b/5e8ceb25753e041b892b588d/2")
        
        let url = urlComponents?.url
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let decoder = JSONDecoder()
            self.products = try! decoder.decode([ProductModel].self, from: data!)
                var categoryProducts: [ProductModel] = []
                for item in self.products {
                    if  item.category == productCategory {
                    categoryProducts.append(item)
                }
                }
                self.products = categoryProducts
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            dataTask.resume()
        }

        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return productViewModel.levelsList.count
            return products.count
        }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell


        let product = products[indexPath.row]
        cell.productImage.image = UIImage(named: product.image)
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
        
      /*  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let detailsViewController = storyboard?.instantiateViewController(identifier: "GlalleryDetailsViewController") as! GlalleryDetailsViewController
            //        detailsViewController.modalPresentationStyle = .fullScreen
                    present(detailsViewController, animated: true, completion: nil)
            
        } */
    



    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if (segue.identifier == "toProductPage")
               {
                    let nextScene = segue.destination as! ProductViewController
                    let cell = sender as! UITableViewCell
                    let index = self.tableView.indexPath(for: cell)
                    nextScene.title = self.products[index?.row ?? 0] as! String
                    nextScene.product = self.products[index?.row ?? 0]
        }
    }
    

}
