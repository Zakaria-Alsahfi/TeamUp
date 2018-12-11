//
//  GoingGames.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class GoingGames: UIViewController {
    
    
    let CellId = "CellId"
    var collectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    var publicGame: [PFObject]! = []
    var privateGame: [PFObject]! = []
    var currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Going Games view controller")
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 320)
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView.register(GoingCell.self, forCellWithReuseIdentifier: CellId)
        collectionView.register(ReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "Header")
        
        collectionView?.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView.backgroundColor = .clear
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPublicEvents()
        loadPrivateEvents()
    }
    
    @objc func loadData(){
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    @objc func loadPublicEvents() {
        let publicEventQuery = PFQuery(className: EVENT_CLASS_NAME)
        publicEventQuery.whereKey("player", containedIn: [currentUser!])
        publicEventQuery.whereKey(GAME_TYPE, equalTo: "Public")
        publicEventQuery.includeKey(GAME_CREATED_BY)
        publicEventQuery.order(byAscending: GAME_START_TIME)
        publicEventQuery.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.publicGame.removeAll(keepingCapacity: true)
                for o in objects! {
                    if self.publicGame.contains(o){
                        self.publicGame.append(o)
                    }
                }
                self.publicGame = objects
                self.collectionView.reloadData()
            } else {
                self.showHUD("Network error")
                print(error as Any)
            }
        }
    }
    
    func loadPrivateEvents() {
        let privateEventQuery = PFQuery(className: EVENT_CLASS_NAME)
        privateEventQuery.whereKey(USER_NAME, equalTo: currentUser?.username as Any)
        privateEventQuery.whereKey("going", containedIn: [currentUser!])
        privateEventQuery.whereKey(GAME_TYPE, equalTo: "Private")
        privateEventQuery.includeKey(GAME_CREATED_BY)
        privateEventQuery.order(byAscending: GAME_START_TIME)
        privateEventQuery.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.privateGame.removeAll(keepingCapacity: false)
                for o in objects! {
                    if self.privateGame.contains(o){
                        self.privateGame.append(o)
                    }
                }
                self.privateGame = objects
                print(self.privateGame.count)
                self.collectionView.reloadData()
            } else {
                self.showHUD("Network error")
                print(error as Any)
            }
        }
    }
}
extension GoingGames: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if publicGame.count == 0 && privateGame.count == 0{
            self.collectionView.setEmptyMessage("you haven't joined any game")
        } else {
            self.collectionView.restore()
        }
        if section == 0 {
            return publicGame.count
        }else {
            return privateGame.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! GoingCell
        
        if indexPath.section == 0 {
            let object = self.publicGame[indexPath.row]
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
            
            cell.gameNameLabel.isHidden = true
            cell.timeLabel.text = object.object(forKey: GAME_START_TIME) as? String
            cell.skillLabel.text = object.object(forKey: GAME_SKILL_LEVEL) as? String
            cell.priceLabel.text = object.object(forKey: PRICE) as? String
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM dd, h:mma"
            let date = formatter.date(from: cell.timeLabel.text!)
            let currentDate = Date()
            let date1 = formatter.string(from: currentDate)
            let current = formatter.date(from: date1)
            
            //current date is greater then the game date
            cell.statesLabel.isHidden = true
            if current?.compareTo(date: date!, toGranularity: .hour) == .orderedDescending {
                cell.statesLabel.isHidden = false
                cell.statesLabel.text = "PAST"
            }
        }else {
            let object = self.privateGame[indexPath.row]
            
            if let commentUser = object["CreatedBy"] as? PFUser {
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
            cell.gameNameLabel.text = object.object(forKey: GAME_TEAM_NAME) as? String
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
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM dd, h:mma"
            let date = formatter.date(from: cell.timeLabel.text!)
            let currentDate = Date()
            let date1 = formatter.string(from: currentDate)
            let current = formatter.date(from: date1)
            
            //current date is greater then the game date
            cell.statesLabel.isHidden = true
            if current?.compareTo(date: date!, toGranularity: .hour) == .orderedDescending {
                cell.statesLabel.isHidden = false
                cell.statesLabel.text = "PAST"
            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! ReusableHeaderView
        header.backgroundColor = .clear
        if indexPath.section == 0 {
            if publicGame.count == 0 {
                header.isHidden = true
            }else {
                header.isHidden = false
                header.nameLabel.text = "Public Games"
            }
        }else {
            if privateGame.count == 0 {
                header.isHidden = true
            }else {
                header.isHidden = false
                header.nameLabel.text = "Private Games"
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            if publicGame.count == 0 {
                return CGSize(width: 0, height: 0)
            }else {
                return CGSize(width: collectionView.bounds.size.width, height: 40)
            }
        }else {
            return CGSize(width: collectionView.bounds.size.width, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let index = self.publicGame[indexPath.row]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameDetailMain") as! GameDetailMain
            vc.objectId = index.objectId!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let index = self.privateGame[indexPath.row]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PrivateGameDetailMain") as! PrivateGameDetailMain
            vc.objectId = index.objectId!
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
