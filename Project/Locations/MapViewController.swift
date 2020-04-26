//
//  MapViewController.swift
//  Project
//
//  Created by Inovium Digital Vision on 08/04/2020.
//  Copyright © 2020 Inovium Digital Vision. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
import Firebase

class MapViewController: UIViewController {
    var locations: [LocationModel] = []
    
    let locationManager = CLLocationManager()
    @IBAction func changeMapType(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            mapView.mapType = .standard
        } else {
            mapView.mapType = .satellite
        }
    }
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCakeShopLocations()
        mapView.delegate = self
        
    }
    
    func getLocationFromDB(success:@escaping (Bool) -> Void) {
        let ref = Firestore.firestore().collection(CollectionPaths.locations)
        
        ref.getDocuments() { (querySnapshot, err) in
            if err != nil {
                print("Error getting documents!")
            } else {
                var currentLocations: [LocationModel] = []
                for document in querySnapshot!.documents {
                    let location = LocationModel()
                    let coords = document.get("coords")
                    let point = coords as! GeoPoint
                    let lat = point.latitude
                    let lon = point.longitude
                    location.latitude = lat
                    location.longitude = lon
                    location.locationTitle = document["locationTitle"] as? String
                    location.locationSubtitle = document["locationSubtitle"] as? String
                    currentLocations.append(location)
                    
                }
                self.locations = currentLocations
                success(true)
            }
        }
    }
    
    func setCakeShopLocations() {
        getLocationFromDB{(success) in
        if success {
            for location in self.locations {
                self.setLocation(location: location)
            }
            self.mapView.reloadInputViews()
            }}
        
    }

    func setLocation(location: LocationModel) {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        let cakeShopLocation = CLLocation(latitude: location.latitude ?? 44.43551249066226, longitude: location.longitude ?? 26.099658608436588)
        let region = MKCoordinateRegion(center: cakeShopLocation.coordinate, latitudinalMeters:500,  longitudinalMeters:100)
        mapView.setRegion(region, animated: true)
      
        
        
        // mark the cake shop location with an annotation
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.latitude ?? 44.43551249066226, longitude: location.longitude ?? 26.099658608436588)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = location.locationTitle
        objectAnnotation.subtitle = location.locationSubtitle
        self.mapView.addAnnotation(objectAnnotation)
        
          mapView.delegate = self
    }


}
extension MapViewController : MKMapViewDelegate{
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("Map randering...")
       // setCakeShopLocations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotation = annotation as? MKPointAnnotation
          let identifier = "marker"
          var view: MKMarkerAnnotationView
          if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
                //print("1")
          } else {
                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            //print(2)
          }
          return view
    }
}
