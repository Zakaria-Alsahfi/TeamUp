//
//  PublicEventVC.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/13/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ProgressHUD


class PublicEventVC: UIViewController, UIPopoverPresentationControllerDelegate {
    
    let query = PFQuery(className: EVENT_CLASS_NAME)
    let EventsCellId = "EventsCellId"
    var collectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    
    
    var Events: [PFObject]! = []
    var currentUser = PFUser.current()
    var userLocation = PFGeoPoint()
    var distance = 0
    var rightBarButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = deepPurple
        self.navigationController?.navigationBar.tintColor = .white
        
        self.rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newEvent(_:)))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        
        let image = UIImage(named: "filter-and-sort")
        self.leftBarButton = UIBarButtonItem(image: image?.withAlignmentRectInsets(UIEdgeInsets(top: 5, left: -20, bottom: -2, right: 0)), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(showAlert(_:)))
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 300)
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView.register(PublicGameCell.self, forCellWithReuseIdentifier: EventsCellId)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "Public Game"
        currentUser?.fetchIfNeededInBackground(block: { (user, error) in
            if error == nil && user != nil {
                self.distance = user?.object(forKey: "distance") as! Int
                self.userLocation = user?.object(forKey: "location") as! PFGeoPoint
                print(self.distance)
                print("This \(self.userLocation.latitude) after update")
                print("This \(self.userLocation.longitude) after update")
            }
        })
        loadEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = " "
        query.cancel()
    }
    
    @objc func loadData(){
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func newEvent(_ sender: Any) {
        DispatchQueue.main.async {
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newEvent") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @objc func loadEvents() {
        query.whereKey(USER_NAME, notEqualTo: currentUser?.username as Any)
        query.whereKey(GAME_TYPE, equalTo: "Public")
        query.whereKey("player", notContainedIn: [currentUser!])
        query.whereKey("coordinate", nearGeoPoint: userLocation, withinMiles: Double(distance))
        let currentDate = Date()
        print(currentDate)
        query.whereKey("gameStartTime", greaterThanOrEqualTo: currentDate)
        query.includeKey(GAME_CREATED_BY)
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.Events.removeAll(keepingCapacity: true)
                for o in objects! {
                        if self.Events.contains(o){
                            self.Events.append(o)
                        }
                }
                self.Events = objects
                print(self.Events.count)
                self.showHUD("looding...")
                self.collectionView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                print(error as Any)
            }
            self.hideHUD()
        }
    }
}

extension PublicEventVC {
    
    @objc func showAlert(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Nearest", style: .destructive , handler:{ (UIAlertAction)in
            self.loadEvents()
            print("User click low-to-high button")
        }))
        alert.addAction(UIAlertAction(title: "$ Low-to-High", style: .default , handler:{ (UIAlertAction)in
            self.SortBylow_to_high()
            print("User click low-to-high button")
        }))
        
        alert.addAction(UIAlertAction(title: "$ High-to-Low", style: .default , handler:{ (UIAlertAction)in
            self.SortByhigh_to_low()
            print("User click high-to-low button")
        }))
        
        alert.addAction(UIAlertAction(title: "Newest", style: .default , handler:{ (UIAlertAction)in
            self.SortByNewest()
            print("User click newest button")
        }))
        
        alert.addAction(UIAlertAction(title: "Oldest", style: .default, handler:{ (UIAlertAction)in
            self.SortByOldest()
            print("User click latest button")
        }))
        
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler:{ (UIAlertAction)in
            print("User click cancel button")
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func SortBylow_to_high(){
        query.whereKey(USER_NAME, notEqualTo: currentUser?.username as Any)
        query.whereKey(GAME_TYPE, equalTo: "Public")
        query.whereKey("player", notContainedIn: [currentUser!])
        query.includeKey("CreatedBy")
        query.order(byAscending: "GameCost")
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.Events.removeAll(keepingCapacity: false)
                for o in objects! {
                    if self.Events.contains(o){
                        self.Events.append(o)
                    }
                }
                self.Events = objects
                print(self.Events.count)
                self.collectionView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                print(error as Any)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    func SortByhigh_to_low(){
        query.whereKey(USER_NAME, notEqualTo: currentUser?.username as Any)
        query.whereKey(GAME_TYPE, equalTo: "Public")
        query.whereKey("player", notContainedIn: [currentUser!])
        query.includeKey("CreatedBy")
        query.order(byDescending: "GameCost")
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.Events.removeAll(keepingCapacity: false)
                for o in objects! {
                    if self.Events.contains(o){
                        self.Events.append(o)
                    }
                }
                self.Events = objects
                print(self.Events.count)
                self.collectionView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                print(error as Any)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    func SortByNewest(){
        query.whereKey(USER_NAME, notEqualTo: currentUser?.username as Any)
        query.whereKey(GAME_TYPE, equalTo: "Public")
        query.whereKey("player", notContainedIn: [currentUser!])
        query.includeKey("CreatedBy")
        query.order(byDescending: "gameStartTime")
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.Events.removeAll(keepingCapacity: false)
                for o in objects! {
                    if self.Events.contains(o){
                        self.Events.append(o)
                    }
                }
                self.Events = objects
                print(self.Events.count)
                self.collectionView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                print(error as Any)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    func SortByOldest(){
        query.whereKey(USER_NAME, notEqualTo: currentUser?.username as Any)
        query.whereKey(GAME_TYPE, equalTo: "Public")
        query.whereKey("player", notContainedIn: [currentUser!])
        query.includeKey("CreatedBy")
        query.order(byAscending: "gameStartTime")
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.Events.removeAll(keepingCapacity: false)
                for o in objects! {
                    if self.Events.contains(o){
                        self.Events.append(o)
                    }
                }
                self.Events = objects
                print(self.Events.count)
                self.collectionView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
                print(error as Any)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
}

extension PublicEventVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Events.count == 0 {
            self.collectionView.setEmptyMessage("There are no new game Near you")
        } else {
            self.collectionView.restore()
        }
        
        return Events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventsCellId, for: indexPath) as! PublicGameCell
        
        let object = self.Events[indexPath.row]
        if let commentUser = object[GAME_CREATED_BY] as? PFUser {
            let profilePicture = commentUser[USER_AVATAR] as? PFFile
            if profilePicture != nil {
                profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.profileImage.image = UIImage(data: imageData)
                        }}})
                
                
            }
            let firstName = commentUser.object(forKey: USER_FIRST_NAME) as? String
            let lastName = commentUser.object(forKey: USER_LAST_NAME) as? String
            cell.nameLabel.text = "\(firstName!) \(lastName!)"
            
        }
        
        cell.LocationLabel.text = object.object(forKey: EVENT_LOCATION_NAME) as? String
        let picture = object.object(forKey: EVENT_IMAGE) as? PFFile
        if picture != nil {
            picture?.getDataInBackground(block: { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.gameImage.image = UIImage(data: imageData)
                    }}})
        }
        cell.timeLabel.text = object.object(forKey: GAME_START_TIME) as? String
        cell.skillLabel.text = object.object(forKey: GAME_SKILL_LEVEL) as? String
        cell.priceLabel.text = object.object(forKey: PRICE) as? String
        
        if object.object(forKey: "coordinate") != nil {
            let coordinate = object.object(forKey: "coordinate") as? PFGeoPoint
            let otherGeoPoint = PFGeoPoint(latitude: (coordinate?.latitude)! , longitude: (coordinate?.longitude)!)
            let latitude = userLocation.latitude
            let longitude = userLocation.longitude
            print(latitude)
            print(longitude)
            let geoPoint = PFGeoPoint(latitude: latitude, longitude: longitude)
            let distance = geoPoint.distanceInMiles(to: otherGeoPoint)
            print(distance)
            if distance <= 1.0 {
                cell.distanceLabel.text = "Less Than 1 Mile"
            }else {
                cell.distanceLabel.text = "\(String(format: "%.f", distance)) Miles"
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PublicGameDetail") as! PublicGameDetail
            let index = self.Events[indexPath.row]
            vc.objectId = index.objectId!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationItem.backBarButtonItem?.tintColor = .white
            
        }
        
    }
}
