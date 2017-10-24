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

    @IBOutlet weak var mapView: MKMapView!
    var curLocationManager: CLLocationManager?
    var currentPin: MKPointAnnotation = MKPointAnnotation()
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
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
        mapView.setCenter(locations[0].coordinate, animated: true)
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
        
    }
    
    @IBAction func startLocating(_ sender: UIButton) {
        if(CLLocationManager.locationServicesEnabled()){
            curLocationManager = CLLocationManager()
            curLocationManager!.delegate = self
            curLocationManager!.requestWhenInUseAuthorization()
            curLocationManager!.startUpdatingLocation()
        }
        
        stopButton.isEnabled = true
        clearButton.isEnabled = true
        startButton.isEnabled = false
    }
    
    
}

