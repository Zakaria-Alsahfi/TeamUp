//
//  GameChat.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/1/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class InvitedPlayerVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var CellId = "CellId"
    var collectionView: UICollectionView!
    var objectId = ""
    var GoingPlayer: [PFUser]! = []
    var NotGoingPlayer: [PFUser]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView.register(InvitedPlayer.self, forCellWithReuseIdentifier: CellId)
        collectionView.register(ReusableHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "Header")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = .clear
        collectionView?.alwaysBounceVertical = true
        loadPlayer()
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return GoingPlayer.count
        }else{
            return NotGoingPlayer.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! InvitedPlayer
        if indexPath.section == 0 {
            let object = self.GoingPlayer[indexPath.row]
            
            let profilePicture = object[USER_AVATAR] as? PFFile
            if profilePicture != nil {
                profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.imageView.image = UIImage(data: imageData)
                            
                        }}})
                
                let firstName = object.object(forKey: USER_FIRST_NAME) as? String
                let lastName = object.object(forKey: USER_LAST_NAME) as? String
                cell.nameLabel.text = "\(firstName!) \(lastName!)"
            }
        }else {
            let object = self.NotGoingPlayer[indexPath.row]
            
            let profilePicture = object[USER_AVATAR] as? PFFile
            if profilePicture != nil {
                profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            cell.imageView.image = UIImage(data: imageData)
                            
                        }}})
                
                let firstName = object.object(forKey: USER_FIRST_NAME) as? String
                let lastName = object.object(forKey: USER_LAST_NAME) as? String
                cell.nameLabel.text = "\(firstName!) \(lastName!)"
            }
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! ReusableHeaderView
        header.backgroundColor = .clear
        if indexPath.section == 0 {
            header.nameLabel.text = "Going"
            
        }else {
            header.nameLabel.text = "Not Going"
            
        }
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.bounds.size.width, height: 30)
    }
    
    func loadPlayer() {
        let goingQuery = PFQuery(className: EVENT_CLASS_NAME)
        goingQuery.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        goingQuery.whereKey(GAME_TYPE, equalTo: "Private")
        
        let notGoingQuery = PFQuery(className: EVENT_CLASS_NAME)
        notGoingQuery.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        notGoingQuery.whereKey(GAME_TYPE, equalTo: "Private")
        
        let userCheck = PFQuery.orQuery(withSubqueries: [goingQuery, notGoingQuery])
        userCheck.includeKeys(["going", "notGoing"])
        userCheck.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                for o in objects! {
                    if let goingPointerObjects = o["going"]! as? [PFUser] {
                        for object in goingPointerObjects {
                            if self.GoingPlayer.contains(object){
                                self.GoingPlayer.append(object)
                            }
                        }
                        self.GoingPlayer = goingPointerObjects
                        print("player: \(self.GoingPlayer.count)")
                    }
                }
                for o in objects! {
                    if o["notGoing"] != nil {
                        if let notGoingPointerObjects = o["notGoing"]! as? [PFUser] {
                            for object in notGoingPointerObjects {
                                if self.NotGoingPlayer.contains(object){
                                    self.NotGoingPlayer.append(object)
                                }
                            }
                            self.NotGoingPlayer = notGoingPointerObjects
                            print("player: \(self.NotGoingPlayer.count)")
                        }
                    }
                }
                self.collectionView.reloadData()
            } else {
                self.showHUD("Network error")
                print(error as Any)
            }
        }
    }
}


