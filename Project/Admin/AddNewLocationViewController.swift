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
        let ref = Firestore.firestore().collection(CollectionPaths.locations).document()
        ref.setData(self.newLocationDictionary) { err in
            if let err = err {
                print("Error creating document: \(err)")
            } else {
                print("Document successfully created")
                let adminLocation = self.storyboard?.instantiateViewController(withIdentifier: "AdminLocationViewController") as! AdminLocationViewController
                adminLocation.modalPresentationStyle = .fullScreen
                self.present(adminLocation, animated: true, completion: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func currentDataAsArray() {
        newLocationDictionary.updateValue(locationTitleTextField.text ?? "", forKey: "locationTitle")
        newLocationDictionary.updateValue(locationSubtitleTextField.text ?? "", forKey: "locationSubtitle")
        let coords = GeoPoint(latitude: Double(latitudeTextField.text!) ?? 44.43551249066226, longitude: Double(longitudeTextField.text!) ?? 26.099658608436588)
        newLocationDictionary.updateValue(coords, forKey: "coords")
        
        
    }

}
