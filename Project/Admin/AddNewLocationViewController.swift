//
//  AddNewLocationViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 25/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class AddNewLocationViewController: UIViewController {

    var newLocationDictionary: [String: Any] = [:]
    
    @IBOutlet weak var locationTitleTextField: UITextField!
    @IBOutlet weak var locationSubtitleTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBAction func addLocationTapped(_ sender: Any) {
        currentDataAsArray()
        
        if checkInputValidity(){
            addNewLocation { (successAdding) in
                if successAdding {
                let adminLocation = self.storyboard?.instantiateViewController(withIdentifier: "AdminLocationViewController") as! AdminLocationViewController
                adminLocation.modalPresentationStyle = .fullScreen
                self.present(adminLocation, animated: true, completion: nil)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func addNewLocation (successAdding: @escaping (Bool) -> Void){
        let ref = Firestore.firestore().collection(CollectionPaths.locations).document()
            ref.setData(self.newLocationDictionary) { err in
            if let err = err {
                print("Error creating document: \(err)")
            } else {
                print("Document successfully created")
                successAdding(true)
            }
        }
        
    }
    
    func checkInputValidity() -> Bool {
        if checkIfInputIsEmpty(inputTextField: locationTitleTextField), checkIfInputIsEmpty(inputTextField: locationSubtitleTextField),
            checkIfInputIsEmpty(inputTextField: longitudeTextField), checkIfInputIsEmpty(inputTextField: latitudeTextField){
            let lat = Double(latitudeTextField.text!)
            let lon = Double(longitudeTextField.text!)
            if  checkCoordinateValidity(lat: lat!, lon: lon!) == true {
                return true
            }
            return false
        }
        return false
    }
    
    func checkCoordinateValidity(lat: Double, lon: Double) -> Bool {
        
        if lat >= -90, lat <= 90, lon >= -90, lon <= 90 {
            return true
        }
        let wrongInputAlert = UIAlertController(title: "Wrong value", message: "Latitude and longitude need to contain values between -90 and 90!", preferredStyle: UIAlertController.Style.alert)
        wrongInputAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(wrongInputAlert, animated: true, completion: nil)
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
        newLocationDictionary.updateValue(locationTitleTextField.text ?? "", forKey: "locationTitle")
        newLocationDictionary.updateValue(locationSubtitleTextField.text ?? "", forKey: "locationSubtitle")
        let coords = GeoPoint(latitude: Double(latitudeTextField.text!) ?? 44.43551249066226, longitude: Double(longitudeTextField.text!) ?? 26.099658608436588)
        newLocationDictionary.updateValue(coords, forKey: "coords")
    }

}
