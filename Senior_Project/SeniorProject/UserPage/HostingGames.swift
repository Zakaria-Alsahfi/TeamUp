//
//  HostingGames.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class HostingGames: UIViewController {
    
    
    let CellId = "CellId"
    var collectionView: UICollectionView!
    var refreshControl:UIRefreshControl!
    var publicGame: [PFObject]! = []
    var privateGame: [PFObject]! = []
    var currentUser = PFUser.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 150)
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView.register(HostingGamesCell.self, forCellWithReuseIdentifier: CellId)
        collectionView.register(ReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "Header")
        
        collectionView?.showsVerticalScrollIndicator = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView.backgroundColor = .clear
        print("Going Games view controller")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPublicEvents()
        loadPrivateEvents()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshControl.endRefreshing()
    }
    @objc func loadData(){
        loadPublicEvents()
        loadPrivateEvents()
    }
    
    
    @objc func loadPublicEvents() {
        let publicEventQuery = PFQuery(className: EVENT_CLASS_NAME)
        publicEventQuery.whereKey(USER_NAME, equalTo: currentUser?.username as Any)
        publicEventQuery.whereKey(GAME_TYPE, equalTo: "Public")
        publicEventQuery.includeKey("CreatedBy")
        publicEventQuery.order(byAscending: GAME_START_TIME)
        publicEventQuery.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.publicGame.removeAll(keepingCapacity: false)
                for o in objects! {
                    if self.publicGame.contains(o){
                        self.publicGame.append(o)
                    }
                }
                self.publicGame = objects
                print(self.publicGame.count)
                self.collectionView.reloadData()
            } else {
                self.showHUD("Network error")
                print(error as Any)
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    func loadPrivateEvents() {
        let privateEventQuery = PFQuery(className: EVENT_CLASS_NAME)
        privateEventQuery.whereKey(USER_NAME, equalTo: currentUser?.username as Any)
        privateEventQuery.whereKey(GAME_TYPE, equalTo: "Private")
        privateEventQuery.includeKey("CreatedBy")
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
            self.refreshControl!.endRefreshing()
        }
    }
    
}



extension HostingGames: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if publicGame.count == 0 && privateGame.count == 0 {
            self.collectionView.setEmptyMessage("you haven't hosted any game")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! HostingGamesCell
        
        if indexPath.section == 0 {
            let object = self.publicGame[indexPath.row]
            let imageFile = object.object(forKey: EVENT_IMAGE) as? PFFile
            if imageFile != nil {
                imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.imageView.image = UIImage(data:imageData)
                            
                        }}})
            }
            
            cell.gameNameLabel.text = " "
            let game_time = object.object(forKey: GAME_START_TIME) as? String
            let start_date = game_time!.index(game_time!.startIndex, offsetBy: 0)
            let end_date = game_time!.index(game_time!.endIndex, offsetBy: -8)
            let date_text = start_date..<end_date
            
            let start_time = game_time!.index(game_time!.startIndex, offsetBy: 12)
            let end_time = game_time!.endIndex
            let time_text = start_time..<end_time
            
            cell.dateLabel.text = "\(game_time![date_text])\n\(game_time![time_text])"
            
            cell.locationLabel.text = object.object(forKey: EVENT_LOCATION_NAME) as? String
            let filled = object.object(forKey: JOINED) as? Int
            cell.filled.text = filled!.toString()
            let requeste = object.object(forKey: COUNTS) as? Int
            cell.requeste.text = requeste?.toString()
            cell.skill.text = object.object(forKey: GAME_SKILL_LEVEL) as? String
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM dd, h:mma"
            let date = formatter.date(from: game_time!)!
            let currentDate = Date()
            let date1 = formatter.string(from: currentDate)
            let current = formatter.date(from: date1)
            
            cell.statesLabel.isHidden = true
            //current date is greater then the game date
            if current?.compareTo(date: date, toGranularity: .hour) == .orderedDescending {
                print("\(date1) is greater then \(date)")
                cell.statesLabel.isHidden = false
                cell.statesLabel.text = "PAST"
            }
        }else {
            let object = self.privateGame[indexPath.row]
            let imageFile = object.object(forKey: EVENT_IMAGE) as? PFFile
            if imageFile != nil {
                imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.imageView.image = UIImage(data:imageData)
                            
                        }}})
            }
            
            cell.gameNameLabel.text = object.object(forKey: GAME_TEAM_NAME) as? String
            let game_time = object.object(forKey: GAME_START_TIME) as? String
            let start_date = game_time!.index(game_time!.startIndex, offsetBy: 0)
            let end_date = game_time!.index(game_time!.endIndex, offsetBy: -8)
            let date_text = start_date..<end_date
            
            let start_time = game_time!.index(game_time!.startIndex, offsetBy: 12)
            let end_time = game_time!.endIndex
            let time_text = start_time..<end_time
            
            cell.dateLabel.text = "\(game_time![date_text])\n\(game_time![time_text])"
            
            cell.locationLabel.text = object.object(forKey: EVENT_LOCATION_NAME) as? String
            let filled = object.object(forKey: JOINED) as? Int
            cell.filled.text = filled!.toString()
            let requeste = object.object(forKey: COUNTS) as? Int
            cell.requeste.text = requeste?.toString()
            cell.skill.text = object.object(forKey: GAME_SKILL_LEVEL) as? String
            
            let formatter = DateFormatter()
            formatter.dateFormat = "E, MMM dd, h:mma"
            let date = formatter.date(from: game_time!)!
            let currentDate = Date()
            let date1 = formatter.string(from: currentDate)
            let current = formatter.date(from: date1)
            
            //current date is greater then the game date
            cell.statesLabel.isHidden = true
            if current?.compareTo(date: date, toGranularity: .hour) == .orderedDescending {
                print("\(date1) is greater then \(date)")
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
        
        return CGSize(width: collectionView.bounds.size.width, height: 40)
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
