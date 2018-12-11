//
//  InvitedGame.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class InvitedGame: UIViewController {
    
    
    let CellId = "CellId"
    var collectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    var Events: [PFObject]! = []
    var currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView.register(InvitedCell.self, forCellWithReuseIdentifier: CellId)
        
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(loadEvents), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView.backgroundColor = .clear
        print("Invited Games view controller")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadEvents()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.endRefreshing()
    }
    
    func objectAtIndexPath(indexPath: IndexPath) -> PFObject {
        return self.Events[indexPath.row]
    }
    
    @objc func loadEvents() {
        let query = PFQuery(className: EVENT_CLASS_NAME)
        query.whereKey("player", containedIn: [currentUser!])
        query.whereKey("user", notEqualTo: currentUser!.username!)
        query.whereKey(GAME_TYPE, equalTo: "Private")
        query.includeKeys(["player", GAME_CREATED_BY])
        query.order(byAscending: UPDATEDAT)
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
                self.showHUD("Network error")
                print(error as Any)
            }
        }
    }
    @objc func Going(_ sender: UIButton){
        sender.isEnabled = false
        let hitPoint = sender.convert(sender.bounds.origin, to: collectionView)
        let hitIndex = collectionView.indexPathForItem(at: hitPoint)
        let object = self.objectAtIndexPath(indexPath: hitIndex!)
        print("good")
        object.removeObjects(in: [PFUser.current()!], forKey: "player")
        object.addObjects(from: [PFUser.current()!], forKey: "going")
        object.saveInBackground()
        loadEvents()
        print(object.objectId!)
    }
    
    @objc func notGoing(_ sender: UIButton){
        sender.isEnabled = false
        let hitPoint = sender.convert(sender.bounds.origin, to: collectionView)
        let hitIndex = collectionView.indexPathForItem(at: hitPoint)
        let object = self.objectAtIndexPath(indexPath: hitIndex!)
        object.removeObjects(in: [PFUser.current()!], forKey: "player")
        object.addObjects(from: [PFUser.current()!], forKey: "notGoing")
        object.saveInBackground()
        loadEvents()
        print(object.objectId!)
    }
}
extension InvitedGame: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Events.count == 0 {
            self.collectionView.setEmptyMessage("You don't have any an invitation request")
        } else {
            self.collectionView.restore()
        }
        
        return Events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! InvitedCell
        let object = self.Events[indexPath.row]
        
        if let commentUser = object[GAME_CREATED_BY] as? PFUser {
            let profilePicture = commentUser[USER_AVATAR] as? PFFile
            if profilePicture != nil {
                profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.imageView.image = UIImage(data:imageData)
                            
                        }}})
                
                
            }
            let firstName = commentUser.object(forKey: USER_FIRST_NAME) as? String
            let lastName = commentUser.object(forKey: USER_LAST_NAME) as? String
            cell.nameLabel.text = "\(firstName!) \(lastName!)"
            print("Created by: \(cell.nameLabel.text!)")
            
        }
        cell.priceLabel.text = object.object(forKey: PRICE) as? String
        
        let game_time = object.object(forKey: GAME_START_TIME) as? String
        let start_date = game_time!.index(game_time!.startIndex, offsetBy: 0)
        let end_date = game_time!.index(game_time!.endIndex, offsetBy: -8)
        let date_text = start_date..<end_date
        
        let start_time = game_time!.index(game_time!.startIndex, offsetBy: 12)
        let end_time = game_time!.endIndex
        let time_text = start_time..<end_time
        
        cell.timeLabel.text = "\(game_time![date_text]) \(game_time![time_text])"
        cell.LocationLabel.text = object.object(forKey: EVENT_LOCATION_NAME) as? String
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd, h:mma"
        let date = formatter.date(from: game_time!)
        let currentDate = Date()
        let date1 = formatter.string(from: currentDate)
        let current = formatter.date(from: date1)
        
        //current date is greater then the game date
        cell.statesLabel.isHidden = true
        if current?.compareTo(date: date!, toGranularity: .hour) == .orderedDescending {
            print("\(String(describing: date1)) is greater then \(String(describing: date))")
            cell.statesLabel.isHidden = false
            cell.statesLabel.text = "PAST"
        }
        
        cell.goingButton.addTarget(self, action: #selector(Going(_:)), for: .touchUpInside)
        cell.notGoingButton.addTarget(self, action: #selector(notGoing(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivateGameDetailMain") as! PrivateGameDetailMain
            let index = self.Events[indexPath.row]
            vc.objectId = index.objectId!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
