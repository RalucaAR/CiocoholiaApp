//
//  AdminLocationViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 25/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class AdminLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var locations: [LocationModel] = []
    var LocationToDeleteUID: String = ""

    @IBAction func AddNewLocationButton(_ sender: Any) {
        let addNewPage  = self.storyboard?.instantiateViewController(withIdentifier: "AddNewLocationViewController") as! AddNewLocationViewController
        addNewPage.modalPresentationStyle = .fullScreen
        self.present(addNewPage, animated: true, completion: nil)
    }
    @IBOutlet weak var locationsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationsTableView.delegate = self
        self.locationsTableView.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool) {
        getLocations{(success) in
            if success {
                DispatchQueue.main.async {
                    self.locationsTableView.reloadData()
                }
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! AddLocationTableViewCell


        let location = locations[indexPath.row]
        //cell.imageView?.image = UIImage(named: location.image ?? "")
        cell.locationNameLabel.text = location.locationTitle
        cell.locationSubtitleLabel.text = location.locationSubtitle
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteLocation(locationToDelete: self.locations[indexPath.row].locationTitle!)
            let deletedData = self.locations[indexPath.row].locationSubtitle!
            print ("Deleted: " + deletedData)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func getLocationToDelete(locationTitle: String, locationToDeleteSucces: @escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection(CollectionPaths.locations)
        ref.getDocuments() { (snapshot, error) in
            if error != nil {
                print("Error at reading current location!")
            }
            else {
                for document in snapshot!.documents {
                    let title = document["locationTitle"] as? String
                    if title == locationTitle {
                        self.LocationToDeleteUID = document.documentID
                        locationToDeleteSucces(true)
                    }
                }
            }
            
        }
    }
    
    func deleteLocation(locationToDelete: String) {
        getLocationToDelete(locationTitle: locationToDelete) { (true) in
            let ref = Firestore.firestore().collection(CollectionPaths.locations)
            ref.document(self.LocationToDeleteUID).delete();
        }
        
    }
    
    func getLocations(success: @escaping (Bool) -> Void){
        let ref = Firestore.firestore().collection(CollectionPaths.locations)
        ref.getDocuments() { (snapshot, error) in
            if error != nil {
                print("Error at admin location reading!")
            }
            else {
                var foundLocations: [LocationModel] = []
                for document in snapshot!.documents {
                    let location = LocationModel()
                    let coords = document["coords"] as? GeoPoint
                    location.latitude = coords?.latitude
                    location.longitude = coords?.longitude
                    location.locationTitle = document["locationTitle"] as? String
                    location.locationSubtitle = document["locationSubtitle"] as? String
                    foundLocations.append(location)
                }
                self.locations = foundLocations
                success(true)
            }
        }
        
    }
    
  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocationDetail" {
            let destinationPage = segue.destination as! EditLocationViewController
            let cell = sender as! UITableViewCell
            let index = self.locationsTableView.indexPath(for: cell)
            destinationPage.title = self.locations[index!.row].locationTitle
            destinationPage.currentLocation = self.locations[index?.row ?? 0]
        }
    }
  

}
