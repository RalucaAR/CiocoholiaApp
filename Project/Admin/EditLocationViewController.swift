//
//  EditLocationViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 25/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class EditLocationViewController: UIViewController {
    var currentLocation: LocationModel!
    var currentArray: [String: Any] = [:]
    var currentLocationUID: String = ""
    
    @IBOutlet weak var locationTitleTextField: UITextField!
    @IBOutlet weak var locationSubtitleTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var latitudeTextField: UITextField!
    
    @IBAction func editLocationButtonTapped(_ sender: Any) {
        currentDataAsArray()
        getCurrentLocationUID{ (success) in
            if success {
                let ref = Firestore.firestore().collection(CollectionPaths.locations).document(self.currentLocationUID)
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

        if currentLocation != nil {
            self.locationTitleTextField.text = currentLocation.locationTitle
            self.locationSubtitleTextField.text = currentLocation.locationSubtitle
            self.latitudeTextField.text = String(format: "%f", currentLocation.latitude!)
            self.longitudeTextField.text = String(format: "%f", currentLocation.longitude!)
        }
        
    }
    
    func getCurrentLocationUID(success: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection(CollectionPaths.locations)
        ref.getDocuments() { (snapshot, error) in
        if error != nil {
            print("Error at admin location edit!")
        }
        else {
            for document in snapshot!.documents {
                let locationTitle = document["locationTitle"] as? String
                if locationTitle == self.currentLocation.locationTitle {
                    self.currentLocationUID = document.documentID
                    success(true)
                }
            }
        }
    }
    }
    
    func currentDataAsArray() {
        currentArray.updateValue(locationTitleTextField.text ?? "", forKey: "locationTitle")
        currentArray.updateValue(locationSubtitleTextField.text ?? "", forKey: "locationSubtitle")
        let coords = GeoPoint(latitude: currentLocation.latitude ?? 44.43551249066226, longitude: currentLocation.longitude ?? 26.099658608436588)
        currentArray.updateValue(coords, forKey: "coords")
        
        
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
