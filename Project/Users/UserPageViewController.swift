//
//  UserPageViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 12/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserPageViewController: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
 
    var usernameString: String?
    var favoritesList: [String] = []
    var favoriteProducts: [ProductModel] = []
    var indicator: ProgressIndicator?
    
    @IBOutlet weak var userFavoriteMessage: UILabel!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
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
    @IBOutlet weak var username: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        
        // set user name on page
        let loggedIn =  UserDefaults.standard.getIsLoggedIn()
        if loggedIn == true{
            username.text = UserDefaults.standard.getLoggedInUserEmail()
        }else {
            username.text = usernameString
        }
        
        let layout = self.favoritesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        layout.minimumInteritemSpacing = 5
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Loading user page...")
        self.view.addSubview(indicator!)
    }
    
     override func viewWillAppear(_ animated: Bool) {
        getUserFavoritesList{ (listSuccess) in
            if listSuccess {
                self.favoritesCollectionView.reloadData()
                
            }
        }
    }
    
    func selectCurrentUser(success: @escaping (Bool) -> Void) {
        indicator!.start()
        guard let currentUser = Auth.auth().currentUser?.uid else { return}
        let ref  = Firestore.firestore().collection(CollectionPaths.users).whereField("uid", isEqualTo: currentUser)
       ref.getDocuments() {
           (snapshot, err) in
           if err != nil {
               print("Error getting document data!")
           }
           else{
               let document = snapshot!.documents.first
                self.favoritesList = document?["favoritesList"] as! [String]
                self.username.text = document?["name"] as? String
                success(true)
           }
    }
    }
    
        func getUserFavoritesList(listSuccess: @escaping (Bool) -> Void) {
        selectCurrentUser{(success) in
            if success {
                self.view.reloadInputViews()
            }
            let ref = Firestore.firestore().collection(CollectionPaths.cakes)
            ref.getDocuments() {
                (snapshot, err) in
                if err != nil {
                    print("Erorr retrieving favorites list!")
                }
                else {
                    var currentList: [ProductModel] = []
                    for document in snapshot!.documents {
                        let currentCake = document["name"] as? String
                        for fav in self.favoritesList {
                            if currentCake == fav {
                                let cake = ProductModel()
                                cake.name = currentCake
                                cake.description = document["description"] as? String
                                cake.price = document["price"] as? String
                                cake.image = document["image"] as? String
                                cake.category = document["category"] as? String
                                currentList.append(cake)
                            }
                        }
                    }
                    self.indicator!.stop()
                    self.favoriteProducts = currentList
                    listSuccess(true)
                }
            }
        }}
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.favoriteProducts.count == 0) {
            self.favoritesCollectionView.setEmptyMessage("You do not have favorite products, yet!😢")
            self.userFavoriteMessage.isHidden = true
        } else {
            self.userFavoriteMessage.isHidden = false
            self.favoritesCollectionView.restore()
        }
        return favoriteProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        ImageLoader.image(for:  NSURL(string: favoriteProducts[indexPath.item].image!)! as URL) { (image) in
            cell.userPageCakeImage.image = image
            
        }
        cell.userPageCakeName!.text = favoriteProducts[indexPath.item].name
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
        productPage.product = favoriteProducts[indexPath.item]
        self.navigationController?.pushViewController(productPage, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 0.5
    }
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
