//
//  ProductViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 07/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class ProductViewController: UIViewController {
 
    var currentUser: String!
    var favoritesList: [String] = []
    var product : ProductModel!
    var indicator: ProgressIndicator!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let ref = Firestore.firestore().collection(CollectionPaths.users).document(self.currentUser!)
        ref.updateData(["favoritesList": FieldValue.arrayRemove([self.navigationItem.title ?? ""])])
        deleteButton.isEnabled = false
        deleteButton.isHidden = true
        favoritesButton.isEnabled = true
        favoritesButton.setTitle("Add to Favorites❤️", for: [])
    }
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var productFirstImage: UIImageView!
    @IBAction func addToFavorites(_ sender: Any) {
        insertToFavoritesList()
        (sender as! UIButton).setTitle("Added to Favorites🥰", for: [])
        (sender as! UIButton).isEnabled = false
        deleteButton.isHidden = false
        deleteButton.isEnabled = true;
    }
    
    
    @IBOutlet weak var addToCartButton: UIButton!
    @IBAction func addToCart(_ sender: Any) {
        insertToShoppingCartItem()
        (sender as! UIButton).setTitle("Added to Cart🥰", for: [])
        (sender as! UIButton).isEnabled = false
    }
    
    @IBOutlet weak var productImageView: UIView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = ProgressIndicator(inview:self.view,loadingViewColor: UIColor.gray, indicatorColor: UIColor.black, msg: "Loading product details...")
        self.view.addSubview(indicator!)
        selectCurentUserUID{ (insertSuccess) in
            if insertSuccess {
                self.view.reloadInputViews()
            }}
        deleteButton.isHidden = true
        if product != nil {
            ImageLoader.image(for:  NSURL(string: product.image!)! as URL) { (image) in
            self.productFirstImage.image = image
            }
            self.productDescription.text = product.description
            self.productPrice.text = product.price
            self.navigationItem.title = product.name
            self.productFirstImage.applyshadowWithCorner(containerView: self.productImageView, cornerRadious: 10)
        }
        selectCurrentUserFavoritesList{ (success) in
            self.indicator!.start()
            if success{
                self.view.reloadInputViews()
            }
        }
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        getProductShoppingCartStatus { (success) in
                   if success {
                       self.view.reloadInputViews()
                       self.indicator!.stop()
                   }
               }
    }
    
    func selectCurrentUserFavoritesList(success: @escaping (Bool) -> Void) {
       let currentUser = Auth.auth().currentUser?.uid
       let ref  = Firestore.firestore().collection(CollectionPaths.users).whereField("uid", isEqualTo: currentUser!)
           ref.getDocuments() {
               (snapshot, err) in
               if err != nil {
                   print("Error getting document data!")
               }
               else{
                   let document = snapshot!.documents.first
                    self.favoritesList = document?["favoritesList"] as! [String]
                    for  fav in self.favoritesList{
                        if fav == self.navigationItem.title {
                            self.favoritesButton.setTitle("Added to Favorites🥰", for: [])
                            self.favoritesButton.isEnabled = false
                            self.deleteButton.isEnabled = true
                            self.deleteButton.isHidden = false
                        }
                    }
                    success(true)
               }
        }
    }
    
    func selectCurentUserUID(insertSuccess: @escaping (Bool) -> Void) {
         let currentUserAuthUID = Auth.auth().currentUser?.uid
         
         Firestore.firestore().collection(CollectionPaths.users).whereField("uid", isEqualTo: currentUserAuthUID!)
             .getDocuments() {
             (snapshot, err) in
             if err != nil {
                 print("Error retrieving current user")
             }
             else {
                 let document = snapshot?.documents.first
                 self.currentUser = document?.documentID
                 insertSuccess(true)
                }
         }
    }
    
    func insertToFavoritesList() {
        selectCurentUserUID{ (insertSuccess) in
            if insertSuccess {
                let ref = Firestore.firestore().collection(CollectionPaths.users).document(self.currentUser!)
                ref.updateData(["favoritesList": FieldValue.arrayUnion([self.navigationItem.title ?? ""])])
            }
        }
    }
    
    func insertToShoppingCartItem() {
        selectCurentUserUID{ (insertSuccess) in
            if insertSuccess {
                let ref = Firestore.firestore().collection(CollectionPaths.users).document(self.currentUser!).collection(CollectionPaths.shoppingCartItems)
                ref.document(self.product.name!).setData([
                    "quantity": 1
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        }
    }
    
    func getProductShoppingCartStatus(success: @escaping (Bool) -> Void) {
        selectCurentUserUID{ (insertSuccess) in
        let ref = Firestore.firestore().collection(CollectionPaths.users).document(self.currentUser!).collection(CollectionPaths.shoppingCartItems)
        ref.getDocuments { (snapshot, error) in
            if error != nil {
                print("Errorat shopping list info retrieving!")
            }
            else {
                for document in snapshot!.documents {
                    let currentProduct = document.documentID
                    if currentProduct == self.product.name {
                        self.addToCartButton.setTitle("Added to Cart🥰", for: [])
                        self.addToCartButton.isEnabled = false
                    }
                }
                success(true)
            }
        }
    }
    }

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
