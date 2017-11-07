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
        mapView.delegate = self
        if(CLLocationManager.locationServicesEnabled()){
            curLocationManager = CLLocationManager()
            curLocationManager!.delegate = self
            curLocationManager!.requestWhenInUseAuthorization()
        }
        stopButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {}

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var delta = locations[0].speed / 1000
        if let curLocation = locations.last {
            myGeocoder.reverseGeocodeLocation(curLocation, completionHandler: {(placemarks, error) -> Void in
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
            if delta < 0 {
                delta = delta * (-1)
            }

            let span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
            let region = MKCoordinateRegion(center: curLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = curLocation.coordinate
            mapView.addAnnotation(annotation)
        }
    }

    @IBAction func clearAllFromMapPins(_ sender: UIButton) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    @IBAction func stopLocating(_ sender: UIButton) {
        curLocationManager!.stopUpdatingLocation()
        stopButton.isEnabled = false
        startButton.isEnabled = true
    }
    
    @IBAction func startLocating(_ sender: UIButton) {
        curLocationManager!.startUpdatingLocation()
        stopButton.isEnabled = true
        startButton.isEnabled = false
    }
    
    
}

