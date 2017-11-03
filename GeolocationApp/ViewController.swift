//
//  ViewController.swift
//  GeolocationApp
//
//  Created by Użytkownik Gość on 24.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    var curLocationManager: CLLocationManager?
    var currentPin: MKPointAnnotation = MKPointAnnotation()
    var myGeocoder: CLGeocoder = CLGeocoder()
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(CLLocationManager.locationServicesEnabled()){
            curLocationManager = CLLocationManager()
            curLocationManager!.delegate = self
            curLocationManager!.requestWhenInUseAuthorization()
        }
        //mapView.delegate = self
        
        clearButton.isEnabled = false
        stopButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region)
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let delta = locations[0].speed / 1000
        myGeocoder.reverseGeocodeLocation(locations[0], completionHandler: {(placemarks, error) -> Void in
            var address = ""
            if let country = placemarks![0].country {
                address = String(describing: country)
            }
            if let city = placemarks![0].locality {
                address = String(describing: "\(city), \(address)")
            }
            if let place = placemarks![0].name {
                address = String(describing: "\(place), \(address)")
            }
            self.addressField.text = address
                
            })

        let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        let region = MKCoordinateRegion(center: locations[0].coordinate, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locations[0].coordinate
        mapView.addAnnotation(annotation)
    }

    @IBAction func clearAllFromMapPins(_ sender: UIButton) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    @IBAction func stopLocating(_ sender: UIButton) {
        curLocationManager!.stopUpdatingLocation()
        clearButton.isEnabled = false
        stopButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    @IBAction func startLocating(_ sender: UIButton) {
        curLocationManager!.startUpdatingLocation()
        stopButton.isEnabled = true
        clearButton.isEnabled = true
        startButton.isEnabled = false
    }
    
    
}

