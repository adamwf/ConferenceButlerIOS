//
//  ACMapVC.swift
//  AtendeeCentral
//
//  Created by Probir Chakraborty on 09/08/16.
//  Copyright © 2016 Probir Chakraborty. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ACMapVC: UIViewController,CLLocationManagerDelegate  {

    var addressStr = NSString()
    var locationManager: CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customInit()
    }

    //MARK:- Memory Management Methods
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 
    //MARK:- Helper Mehtods
    func customInit() {
        activityIndicator.startAnimating()
        self.navigationItem.title = "Map"
        self.navigationItem.leftBarButtonItem = ACAppUtilities.leftBarButton("backArrow",controller: self)
        self.getAnnotationFromAddress(addressStr)
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.delegate = self
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(button : UIButton) {
        self.view .endEditing(true)
        self.navigationController?.popViewControllerAnimated(true)
    }

    func getAnnotationFromAddress(address : NSString) {
        let location: String = address as String
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(location,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                var region: MKCoordinateRegion = self.mapView.region
                
                region.center.latitude = (placemark.location?.coordinate.latitude)!
                region.center.longitude = (placemark.location?.coordinate.longitude)!
                
                region.span = MKCoordinateSpanMake(0.5, 0.5)
                
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(placemark)
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidesWhenStopped = true
        })
        
    }
    
    
        func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
            self.locationManager.stopUpdatingLocation()
    
            let latestLocation = locations.last
    
    //        let latitude = String(format: "%.4f", latestLocation!.coordinate.latitude)
    //        let longitude = String(format: "%.4f", latestLocation!.coordinate.longitude)
    
            let center = CLLocationCoordinate2D(latitude: latestLocation!.coordinate.latitude, longitude: latestLocation!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
            self.mapView.setRegion(region, animated: true)
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = (latestLocation?.coordinate)!
            dropPin.title = "Hello"
            self.mapView.addAnnotation(dropPin)
    //        print("Latitude: \(latitude)")
    //        print("Longitude: \(longitude)")
        }
}
