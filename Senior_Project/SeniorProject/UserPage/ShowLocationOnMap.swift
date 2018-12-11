//
//  ShowLocationOnMap.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/30/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ShowLocationOnMap: UIViewController {
    
    var objectId = ""
    var Title: String!
    var SubTitle: String!
    var coordinate: PFGeoPoint!
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        mapView.delegate = self
        self.title = "Game Location"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         getLocationData()
    }
    func setUpViews(){
        view.addSubview(mapView)
        
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func getLocationData(){
        let locationQuery = PFQuery(className: EVENT_CLASS_NAME)
        locationQuery.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        locationQuery.getFirstObjectInBackground { (object, error) in
            if error == nil {
                self.Title = object?.object(forKey: "locationName") as? String
                self.SubTitle = object?.object(forKey: "city") as? String
                self.coordinate = object?.object(forKey: "coordinate") as? PFGeoPoint
                
                print("\(self.Title!) \(self.SubTitle!) \(self.coordinate!)")
                
                let pin = customPin(pinTitle: self.Title,
                                    pinSubTitle: self.SubTitle , discipline: "Sculpture", location: CLLocationCoordinate2D(latitude: self.coordinate.latitude , longitude: self.coordinate.longitude) )
                self.mapView.addAnnotation(pin)
                let center =  CLLocationCoordinate2DMake(self.coordinate.latitude , self.coordinate.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                let region = MKCoordinateRegion(center : center, span : span)
                self.mapView.setRegion(region, animated: true)
                
            }
        }
    }
}



















extension ShowLocationOnMap: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? customPin else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! customPin
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
