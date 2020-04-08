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

class MapViewController: UIViewController {

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

        setCakeShopLocation()
    }
    
    func setCakeShopLocation() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        let cakeShopLocation = CLLocation(latitude: 44.43551249066226, longitude: 26.099658608436588)
        let regionRadius: CLLocationDistance = 900.0
        let region = MKCoordinateRegion(center: cakeShopLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters:regionRadius)
        mapView.setRegion(region, animated: true)
        mapView.delegate = self
        
        // mark the cake shop location with an annotation
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 44.43551249066226, longitude: 26.099658608436588)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "CiocoholiaCakeSop"
        self.mapView.addAnnotation(objectAnnotation)
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

extension MapViewController : MKMapViewDelegate{
    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
        print("Map randering...")
    }
}
