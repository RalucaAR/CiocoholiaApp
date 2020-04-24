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
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let ref = Firestore.firestore().collection(CollectionPaths.users).document(self.currentUser!)
        ref.updateData(["favoritesList": FieldValue.arrayRemove([self.navigationItem.title ?? ""])])
        deleteButton.isHidden = true
        favoritesButton.isEnabled = true
    }
    @IBOutlet weak var favoritesButton: UIButton!
    @IBOutlet weak var productFirstImage: UIImageView!
    @IBAction func addToFavorites(_ sender: Any) {
        insertToFavoritesList()
        (sender as! UIButton).setTitle("Added to Favorites🥰", for: [])
        (sender as! UIButton).isEnabled = false
        deleteButton.isHidden = false
    }
    
    @IBOutlet weak var productImageView: UIView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productPrice: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectCurentUserUID{ (insertSuccess) in
            if insertSuccess {
                self.view.reloadInputViews()
            }}
        deleteButton.isHidden = true
        if product != nil {
            self.productDescription.text = product.description
            self.productFirstImage.image = UIImage(named: product.image ?? "")
            self.productPrice.text = product.price
            self.navigationItem.title = product.name
            self.productFirstImage.applyshadowWithCorner(containerView: self.productImageView, cornerRadious: 10)
        }
        selectCurrentUserFavoritesList{ (success) in
            if success{
                self.view.reloadInputViews()
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
                            self.deleteButton.isHidden = false;
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
