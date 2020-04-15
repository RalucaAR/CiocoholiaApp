//
//  ProductViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 07/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import CoreData

class ProductViewController: UIViewController {
 
    var loggedUser: Users?
    var favoritesList: FavoritesList?
    var product : ProductModel!
    
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var productFirstImage: UIImageView!
    @IBAction func addToFavorites(_ sender: Any) {
            insertToFavoritesList()
            (sender as! UIButton).setTitle("Added to Favorites🥰", for: [])
            (sender as! UIButton).isEnabled = false
    }
    @IBOutlet weak var productImageView: UIView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        if product != nil {
            self.productDescription.text = product.description
            self.productFirstImage.image = UIImage(named: product.image)
            self.productPrice.text = product.price
            self.navigationItem.title = product.name
            self.productFirstImage.applyshadowWithCorner(containerView: self.productImageView, cornerRadious: 10)
        }
        setCurrentUser()
        getUserFavoritesList()
        
        
    }
    
    func setCurrentUser() {
        let loggedInEmail = UserDefaults.standard.getLoggedInUserEmail()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        do {
            let users = try managedContext.fetch(fetchRequest)
            for user in users as! [Users]{
                let selectedUserName = user.value(forKey: "email") as? String
                if selectedUserName == loggedInEmail{
                    loggedUser = user
                }
            }
        }catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    func insertToFavoritesList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let favoritesEntity = NSEntityDescription.entity(forEntityName: "FavoritesList", in: managedContext) else {return }
        let favorites = NSManagedObject(entity: favoritesEntity, insertInto: managedContext)
        favorites.setValue(product.name, forKey: "productId")
        favorites.setValue(loggedUser, forKey: "owner")
        do {
            try managedContext.save()
            print("inserted \(favorites)")
        }catch let error as NSError{
            print(error)
        }
        
    }
    
    func getUserFavoritesList() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesList")
        do{
            let favorites = try managedContext.fetch(fetchRequest)
            for fav in favorites as! [FavoritesList]{
                if fav.productId == self.navigationItem.title, fav.owner == loggedUser{
                    self.favoritesButton.setTitle("Added to Favorites🥰", for: [])
                    self.favoritesButton.isEnabled = false
                }
            }
        }catch let error as NSError {
            print(error)
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
extension UIImageView {
func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
    containerView.clipsToBounds = false
    containerView.layer.shadowColor = UIColor.orange.cgColor
    containerView.layer.shadowOpacity = 1
    containerView.layer.shadowOffset = CGSize.zero
    containerView.layer.shadowRadius = 10
    containerView.layer.cornerRadius = cornerRadious
    containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadious
}
}
