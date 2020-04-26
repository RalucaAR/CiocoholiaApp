//
//  AddProductViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 26/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AddProductViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var newProductDictionary: [String: Any] = [:]
    var imageUrl: String!
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productCategoryTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    
    @IBAction func addProductTapped(_ sender: Any) {
        currentDataAsArray()
        // check the image upload
        if imageUrl != nil {
            newProductDictionary.updateValue(imageUrl!, forKey: "image")
        }
        if checkInputValidity(){
            addNewProduct { (successAdding) in
                if successAdding {
                let adminLocation = self.storyboard?.instantiateViewController(withIdentifier: "AdminCakesViewController") as! AdminCakesViewController
                adminLocation.modalPresentationStyle = .fullScreen
                self.present(adminLocation, animated: true, completion: nil)
                }
            }
        }
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        productImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePicture))
        productImage.addGestureRecognizer(gestureRecognizer)
        // Do any additional setup after loading the view.
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
    
    
    func addNewProduct (successAdding: @escaping (Bool) -> Void){
           let ref = Firestore.firestore().collection(CollectionPaths.cakes).document()
               ref.setData(self.newProductDictionary) { err in
               if let err = err {
                   print("Error creating document: \(err)")
               } else {
                   print("Document successfully created")
                   successAdding(true)
               }
           }
           
       }
       
       func checkInputValidity() -> Bool {
           if checkIfInputIsEmpty(inputTextField: productNameTextField), checkIfInputIsEmpty(inputTextField: productCategoryTextField),
            checkIfInputIsEmpty(inputTextField: productPriceTextField) {
                   return true
               }
               return false

       }
       
       func checkIfInputIsEmpty(inputTextField: UITextField) -> Bool {
           guard let inputText = inputTextField.text, !inputText.isEmpty else {
               let emptyInputAlert = UIAlertController(title: "Empty \(inputTextField.placeholder ?? "input")", message: "No input provided for \(inputTextField.placeholder ?? "")!", preferredStyle: UIAlertController.Style.alert)
               emptyInputAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
               present(emptyInputAlert, animated: true, completion: nil)
               return false
           }
           return true
       }
       

       func currentDataAsArray() {
           newProductDictionary.updateValue(productNameTextField.text ?? "", forKey: "name")
           newProductDictionary.updateValue(productCategoryTextField.text ?? "", forKey: "category")
           newProductDictionary.updateValue(productDescriptionTextView.text ?? "", forKey: "description")
           newProductDictionary.updateValue(productPriceTextField.text ?? "", forKey: "price")
    
       }
    
    

}
