//
//  LocationPreference.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/21/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import MapKit
import Parse

class LocationPreference: UIViewController {
    
    var circle = MKCircle()
    var coords : CLLocationCoordinate2D?
    var span = MKCoordinateSpan()
    var center =  CLLocationCoordinate2D()
    var region = MKCoordinateRegion()
    let annotation = MKPointAnnotation()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var flag : Int = 0
    var tag : Int = 0
    var coordinate = 0.0
    var latitude = 0.0
    var longitude = 0.0
    let radiusValue = 1609.34
    var radius = 0.0
    var county = ""
    let currentUser = PFUser.current()!
    var sliderValue: Float = 1
    
    
    
    
    var currentLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Current Location", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = deepPurple
        button.layer.cornerRadius = 15
        button.layer.shadowRadius = 4.0
        button.layer.shadowOpacity = 0.9
        button.layer.shadowOffset = .zero
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let mapView: MKMapView = {
        let map = MKMapView()
        map.mapType = .standard
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    let searchTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .white
        text.textAlignment = .justified
        text.layer.borderColor = UIColor.purple.cgColor
        text.layer.borderWidth = 1
        text.clipsToBounds = true
        text.placeholder = "Search by City"
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .search
        text.withImage(direction: .Left, image: UIImage(named: "search-filled")!)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var searchResultsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .clear
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let myView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.text = "How far I'll travel to play"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = deepPurple
        slider.maximumTrackTintColor = .lightGray
        slider.thumbTintColor = .white
        slider.thumbImage(for: .normal)
        slider.maximumValue = 60
        slider.minimumValue = 1
        slider.setValue(1, animated: false)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = deepPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = "My Location"
        
        getCurrentLocation()
        
        mapView.delegate = self
        searchTextField.delegate = self
        setUpView()
        
        radius = radiusValue * Double(slider.value)
        distanceLabel.text = String(Int(slider.value)) + " mile"
        
        slider.addTarget(self, action: #selector(changeVlaue(_:)), for: .valueChanged)
        
        currentLocationButton.addTarget(self, action: #selector(getCurrentLocation), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveLocationButt(_:)), for: .touchUpInside)
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        county = placemark.name!
        print(county)
        print(placemark.locality!)
        print(placemark.postalCode!)
        print(placemark.administrativeArea!)
        print(placemark.country!)
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        mapView.removeOverlay(circle)
        sliderValue = sender.value
        if Int(sliderValue) == 1 {
            distanceLabel.text = String(Int(sliderValue)) + " mile"
        }else {
            distanceLabel.text = String(Int(sliderValue)) + " miles"
        }
        let newRadius = radiusValue * Double(sliderValue)
        circle = MKCircle(center : coords!, radius: CLLocationDistance(newRadius))
        mapView.visibleMapRect = mapView.mapRectThatFits(circle.boundingMapRect)
        mapView.addOverlay(circle)
    }
    
    @objc func getCurrentLocation(){
        PFGeoPoint.geoPointForCurrentLocation {(geopoint, error) in
            if error != nil {
                print(error as Any)
            }else{
                if let userLocation = geopoint {
                    self.latitude = userLocation.latitude
                    self.longitude = userLocation.longitude
                    self.displayLocation(Location: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
                    print(self.latitude)
                    print(self.longitude)
                    
                }
            }
        }
    }
    
    func displayLocation(Location: CLLocationCoordinate2D){
        
        self.center =  CLLocationCoordinate2DMake(Location.latitude , Location.longitude)
        self.span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
        self.region = MKCoordinateRegion(center : self.center, span : self.span)
        self.coords = self.center
        self.mapView.setRegion(self.region, animated: true)
        self.circle = MKCircle(center : self.coords!, radius: CLLocationDistance(self.radius))
        self.mapView.visibleMapRect = self.mapView.mapRectThatFits(self.circle.boundingMapRect)
        
        self.annotation.coordinate = self.coords!
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.addAnnotation(self.annotation)
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.addOverlay(self.circle)
    }
    
    @objc func saveLocationButt(_ sender: Any) {
        
        showHUD("Saving...")
        let myGeoPoint = PFGeoPoint(latitude: latitude, longitude: longitude)
        currentUser["location"] = myGeoPoint
        currentUser["distance"] = Int(slider.value)
        
        currentUser.saveInBackground { (success, error) -> Void in
            if error == nil {
                DispatchQueue.main.async {
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToHomePage")
                    self.present(viewController, animated: true, completion: nil)
                }
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
            }}
    }
    
    func setUpView(){
        
        view.addSubview(mapView)
        mapView.addSubview(currentLocationButton)
        mapView.addSubview(searchTextField)
        mapView.addSubview(searchResultsTableView)
        view.addSubview(myView)
        myView.addSubview(textLabel)
        myView.addSubview(slider)
        myView.addSubview(distanceLabel)
        view.addSubview(saveButton)
        print(myView.frame)
        
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        mapView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        
        searchTextField.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 40).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -20).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        searchResultsTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor).isActive = true
        searchResultsTableView.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 20).isActive = true
        searchResultsTableView.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -20).isActive = true
        searchResultsTableView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        
        currentLocationButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        currentLocationButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        currentLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -8).isActive = true
        currentLocationButton.centerXAnchor.constraint(equalTo: mapView.centerXAnchor).isActive = true
        
        myView.topAnchor.constraint(equalTo: mapView.bottomAnchor).isActive = true
        myView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        myView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        textLabel.topAnchor.constraint(equalTo: myView.topAnchor, constant: 10).isActive = true
        textLabel.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 5).isActive = true
        
        slider.topAnchor.constraint(equalTo: textLabel.topAnchor, constant: 30).isActive = true
        slider.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10).isActive = true
        slider.rightAnchor.constraint(equalTo: myView.rightAnchor, constant: -10).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: 10).isActive = true
        distanceLabel.leftAnchor.constraint(equalTo: myView.leftAnchor, constant: 10).isActive = true
        distanceLabel.widthAnchor.constraint(equalTo: myView.widthAnchor).isActive = true
        distanceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: myView.bottomAnchor).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}


























extension LocationPreference : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        searchResultsTableView.isHidden = false
        searchResultsTableView.reloadData()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text
        searchCompleter.queryFragment = text!
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // User finished typing (hit return): hide the keyboard.
        textField.resignFirstResponder()
        searchResultsTableView.isHidden = true
        searchTextField.text = ""
        print(searchCompleter.results.count)
        return true
    }
}


extension LocationPreference : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "checkmark"), for: [])
        pinView?.rightCalloutAccessoryView = button
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        // If you want to include other shapes, then this check is needed. If you only want circles, then remove it.
        let circleOverlay = overlay as? MKCircle
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay!)
        circleRenderer.fillColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
        return circleRenderer
    }
    
}
extension LocationPreference: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
    }
}

extension LocationPreference: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchResults.count == 0 {
            return 0
        }else {
            return searchResults.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension LocationPreference: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.isHidden = true
        searchTextField.resignFirstResponder()
        searchTextField.text = ""
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let coordinate = response?.mapItems[0].placemark.coordinate
            let placeName = response?.mapItems[0].placemark.name
            print(placeName!)
            print(coordinate!)
            self.latitude = coordinate!.latitude
            self.longitude = coordinate!.longitude
            print(self.latitude)
            print(self.longitude)
            self.center =  CLLocationCoordinate2DMake(self.latitude , self.longitude)
            self.span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            self.region = MKCoordinateRegion(center : self.center, span : self.span)
            self.coords = coordinate!
            self.mapView.setRegion(self.region, animated: true)
            self.circle = MKCircle(center : self.coords!, radius: CLLocationDistance(self.radius))
            self.mapView.visibleMapRect = self.mapView.mapRectThatFits(self.circle.boundingMapRect)
            
            self.annotation.coordinate = self.coords!
            self.annotation.title = placeName!
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.addAnnotation(self.annotation)
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(self.circle)
        }
    }
}

