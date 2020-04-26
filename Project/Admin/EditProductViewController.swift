//
//  EditProductViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 26/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var product: ProductModel!
    var currentArray: [String: Any] = [:]
    var currentProductUID: String = ""
    var imageUrl: String!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productCategoryTextFiled: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDescriptionText: UITextView!
    
    @IBAction func uploadPhotoTapped(_ sender: Any) {
        let storage = Storage.storage()
               let storageRef = storage.reference()
               
               let mediaFolder = storageRef.child("cakes")
               
               if let data = productImage.image?.jpegData(compressionQuality: 0.5){
                   let uuid = UUID().uuidString
                   
                   let imageReference = mediaFolder.child("\(uuid).jpg")
                   
                   imageReference.putData(data, metadata: nil){
                   (metadata, error) in
                   if error != nil {
                   
                       print("Error uploading Admin cakes photos=!")
                   } else {
                       imageReference.downloadURL{
                           (url, error) in
                           if error == nil {
                               self.imageUrl = url!.absoluteString
                               
                           }
                       }
                       }
                   }
               }
    }
    
    
    @IBAction func editProductTapped(_ sender: Any) {
        currentDataAsArray()
        //check imageUrl
        if imageUrl != nil {
            currentArray.updateValue(imageUrl!, forKey: "image")
        }
        getCurrentProductUID{ (success) in
            if success {
                let ref = Firestore.firestore().collection(CollectionPaths.cakes).document(self.currentProductUID)
                ref.updateData(self.currentArray) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if product != nil {
            ImageLoader.image(for:  NSURL(string: product.image!)! as URL) { (image) in
                self.productImage.image = image
            }
            
            productNameTextField.text = product.name
            productCategoryTextFiled.text = product.category
            productPriceTextField.text = product.price
            productDescriptionText.text = product.description
        }
        
        productImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        productImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func choosePicture(){
           let picker = UIImagePickerController()
           picker.delegate = self
           picker.sourceType = .photoLibrary
           self.present(picker, animated: true, completion: nil)
       }
       
       func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
           productImage.image = info[.originalImage] as? UIImage
           self.dismiss(animated: true, completion: nil)
       }
       
       func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
       }
    
    func getCurrentProductUID(success: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection(CollectionPaths.cakes)
        ref.getDocuments() { (snapshot, error) in
        if error != nil {
            print("Error at admin location edit!")
        }
        else {
            for document in snapshot!.documents {
                let cakeName = document["name"] as? String
                if cakeName == self.product.name {
                    self.currentProductUID = document.documentID
                    success(true)
                }
            }
        }
    }
    }
    
    func currentDataAsArray() {
        currentArray.updateValue(productNameTextField.text ?? "", forKey: "name")
        currentArray.updateValue(productPriceTextField.text ?? "", forKey: "price")
        currentArray.updateValue(productCategoryTextFiled.text ?? "", forKey: "category")
        currentArray.updateValue(productDescriptionText.text ?? "", forKey: "description")
        
    }
    
    

}
