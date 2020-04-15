//
//  UserPageViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 12/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import CoreData

class UserPageViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var loggedUser: Users?
    var usernameString: String?
    var productList: [String] = []
    var APIProducts: [ProductModel] = []
    
    @IBOutlet weak var userFavoriteMessage: UILabel!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    @IBAction func logoutAction(_ sender: Any) {
        UserDefaults.standard.setIsLoggedIn(value: false)
        UserDefaults.standard.setLoggedInUserEmail(value: "NotLoggedIn")
        // show login page
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(loginPage, animated: true, completion: nil)
    }
    @IBOutlet weak var username: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        //getUserFavoritesList()
        //getFavoritesListFromAPI()
        
        // set user name on page
        let loggedIn =  UserDefaults.standard.getIsLoggedIn()
        if loggedIn == true{
            selectCurrentUser()
            username.text = loggedUser?.name
        }else {
        username.text = usernameString
        }
        
        let layout = self.favoritesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
    }
    
     override func viewWillAppear(_ animated: Bool) {
        getUserFavoritesList()
        getFavoritesListFromAPI()
    }
    
    func selectCurrentUser() {
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
    
    func getUserFavoritesList() {
        selectCurrentUser()
        productList = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritesList")
        do {
            let favorites = try managedContext.fetch(fetchRequest)
            for favorite in favorites as! [FavoritesList]{
                let user = favorite.value(forKey: "owner") as? Users
                let favoriteProduct = favorite.value(forKey: "ProductId") as? String
                if user == loggedUser{
                    productList.append(favoriteProduct!)
                }
            }
        }catch let error as NSError {
            print("Error: \(error)")
        }
        
    }
    
    func getFavoritesListFromAPI()
    {
        _ = URLSession(configuration: .default)
               
               let urlComponents = URLComponents(string: "https://api.jsonbin.io/b/5e8ceb25753e041b892b588d/2")
               
               let url = urlComponents?.url
               let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                   let decoder = JSONDecoder()
                    var apiProducts:[ProductModel] = []
                    apiProducts = try! decoder.decode([ProductModel].self, from: data!)
                       var favoriteProducts: [ProductModel] = []
                       for item in apiProducts {
                        for fav in self.productList {
                            if  item.name == fav {
                           favoriteProducts.append(item)
                       }
                        }
                       }
                       self.APIProducts = favoriteProducts
                       DispatchQueue.main.async {
                        self.favoritesCollectionView.reloadData()
                       }
                   }
                   dataTask.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.APIProducts.count == 0) {
            self.favoritesCollectionView.setEmptyMessage("You do not have favorite products, yet!😢")
            self.userFavoriteMessage.isHidden = true
        } else {
            self.userFavoriteMessage.isHidden = false
            self.favoritesCollectionView.restore()
        }
        return APIProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.userPageCakeImage!.image = UIImage(named: APIProducts[indexPath.item].image)
        cell.userPageCakeName!.text = APIProducts[indexPath.item].name
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    let padding: CGFloat =  95
    let collectionViewSize = favoritesCollectionView.frame.size.width - padding
    let collectionViewHeigth = favoritesCollectionView.frame.size.height
    return CGSize(width: collectionViewSize/2, height: collectionViewHeigth/6)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.orange.cgColor
        cell?.layer.borderWidth = 2
        let productPage = self.storyboard?.instantiateViewController(identifier: "ProductViewController") as! ProductViewController
        productPage.product = APIProducts[indexPath.item]
        self.navigationController?.pushViewController(productPage, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 0.5
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

extension UICollectionView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .orange
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}
