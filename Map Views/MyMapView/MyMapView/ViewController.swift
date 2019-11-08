//
//  ViewController.swift
//  MyMapView
//
//  Created by Neha Pant on 27/09/2019.
//  Copyright © 2019 Neha Pant. All rights reserved.
//


//Because many map operations require the MKMapView class to load data asynchronously, the map view calls these methods to notify your application when specific operations complete. The map view also uses these methods to request annotation and overlay views and to manage interactions with those views.
//Before releasing an MKMapView object for which you have set a delegate, remember to set that object’s delegate property to nil. MapKit calls all of your delegate methods on the app's main thread.


//Import MapKit
//Add CLLocationManager to get the current location

//USer will be asked with pop up that device can use its current location
//Add it in Info.plist to get user current location
//Privacy - Location Always and When In Use Usage Description
//Privacy - Location When In Use Usage Description

//Add mapView in StoryBoard
//Set map view delegates

//Add Extension and add delegate method

//Add Annotation View for adding customised icon
//Set Location Manager delegate to get the current location didUpdateLocations

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotationView:MKAnnotationView?
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
    }
}

extension ViewController: MKMapViewDelegate {
    //Deleaget to set For Annotion view with custom Icon
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let annotationIdentifier = "AnnotationIdentifier"
        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
        }else {
            annotationView?.annotation = annotation
        }
        annotationView?.image = UIImage(named: "location-pin")
        return annotationView
    }
    
    //Delegate to get the Current location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let newPin = MKPointAnnotation()
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            //set region on the map
            mapView.setRegion(region, animated: true)
            newPin.coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //When coordinates nil for first time
            if mapView.annotations.count <= 0 {
                mapView.addAnnotation(newPin)
            }
        }
    }
}

