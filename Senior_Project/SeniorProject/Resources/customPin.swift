//
//  customPin.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/31/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

class customPin: NSObject, MKAnnotation {
    
    var title: String?
    let locationName: String?
    let discipline: String?
    var coordinate: CLLocationCoordinate2D
    
    init( pinTitle: String, pinSubTitle: String, discipline: String, location:CLLocationCoordinate2D) {
        self.title = pinTitle
        self.locationName = pinSubTitle
        self.discipline = discipline
        self.coordinate = location
        super.init()
    }
    var subtitle: String? {
        return locationName
        
    }
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subtitle!]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
    
    
//    class Artwork: NSObject, MKAnnotation {
//        let title: String?
//        let locationName: String
//        let discipline: String
//        let coordinate: CLLocationCoordinate2D
//
//        init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
//            self.title = title
//            self.locationName = locationName
//            self.discipline = discipline
//            self.coordinate = coordinate
//
//            super.init()
//        }
//
//        var subtitle: String? {
//            return locationName
//        }
//    }
}
