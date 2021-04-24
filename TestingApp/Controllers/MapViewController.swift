//
//  MapViewController.swift
//  TestingApp
//
//  Created by Daniel Duan on 4/19/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import SCLAlertView
import RealmSwift

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    // IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var verifyLocationBtn: UIButton!
    
    
    var testingSites = [TestingSite]()
    var userLocation = CLLocationCoordinate2D()
    
    
    let manager = CLLocationManager()
    
    let realm = try! Realm()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        updateTestingSites()
    }
    
    func prepareViews() {
        verifyLocationBtn.layer.cornerRadius = 15
    }
    
    func updateTestingSites() {
        
        let duboisTent = TestingSite(locationName: "Du Bois Tent", locationCoordinate: CLLocationCoordinate2D(latitude: 39.95299775260588, longitude: -75.2007223867476))
        let annenbergCenter = TestingSite(locationName: "Annenberg Center", locationCoordinate: CLLocationCoordinate2D(latitude: 39.952827275873595, longitude: -75.19659495096569))
        let houstonHall = TestingSite(locationName: "Houston Hall", locationCoordinate: CLLocationCoordinate2D(latitude: 39.95087470743933, longitude: -75.1936723729526))
        let richardsTent = TestingSite(locationName: "Richards Tent", locationCoordinate: CLLocationCoordinate2D(latitude: 39.949858135599136, longitude: -75.19786337869708))
        let irvineAuditorium = TestingSite(locationName: "Irvine Auditorium", locationCoordinate: CLLocationCoordinate2D(latitude: 39.95089971073784, longitude: -75.19299566073967))
        let aceAdamsTent = TestingSite(locationName: "Ace Adams Tent", locationCoordinate: CLLocationCoordinate2D(latitude: 39.94994032538263, longitude: -75.18548038659442))
                        
        testingSites.append(duboisTent)
        testingSites.append(annenbergCenter)
        testingSites.append(houstonHall)
        testingSites.append(richardsTent)
        testingSites.append(irvineAuditorium)
        testingSites.append(aceAdamsTent)
        
        // create pins
        for location in testingSites {
            let pin = MKPointAnnotation()
            pin.coordinate = location.locationCoordinate
            pin.title = location.locationName
            mapView.addAnnotation(pin)
        }
    }
 
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            render(userLocation)
        }
    }
    
    func render(_ coordinate: CLLocationCoordinate2D) {
        
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @IBAction func verifyLocationBtnPressed(_ sender: UIButton) {
        
        let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        var testingSiteName = ""
        var atTestedLocation = false
        
        for location in testingSites {
            let siteLocation = CLLocation(latitude: location.locationCoordinate.latitude, longitude: location.locationCoordinate.longitude)
            let distanceInMeters = siteLocation.distance(from: user)
            if distanceInMeters < 35 {
                atTestedLocation = true
                testingSiteName = location.locationName
                break
            }
        }
        
        if atTestedLocation {
            let _: SCLAlertViewResponder = SCLAlertView().showSuccess("Tested!", subTitle: "Thank you for testing at \(testingSiteName)!")
            performSegue(withIdentifier: "unwindFromMap", sender: self)
        } else {
            let _: SCLAlertViewResponder = SCLAlertView().showError("Error", subTitle: "It seems like you're not at a testing site yet...")
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromMap" {
            if let vc = segue.destination as? HomeViewController {
                
                let testCount = realm.objects(TestCount.self).first
                try! realm.write {
                    testCount!.testCount = testCount!.testCount + 1
                }
                vc.updateAvatar()
                vc.disableCheckInButton()
            }

        }
    }
    
    
    
}
