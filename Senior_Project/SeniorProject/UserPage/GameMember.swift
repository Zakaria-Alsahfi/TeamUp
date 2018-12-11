//
//  GameMember.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 11/5/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class GameMember: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var CellId = "CellId"
    var collectionView: UICollectionView!
    var objectId = ""
    var playerList: [PFUser]! = []
    let query = PFQuery(className: EVENT_CLASS_NAME)
    
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
        collectionView.register(Player.self, forCellWithReuseIdentifier: CellId)
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = .clear
        collectionView?.alwaysBounceVertical = true
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPlayer()
    }
    override func viewWillDisappear(_ animated: Bool) {
//        query.cancel()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playerList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! Player
        let object = playerList[indexPath.row]
        
        let profilePicture = object[USER_AVATAR] as? PFFile
        if profilePicture != nil {
            profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.imageView.image = UIImage(data: imageData)
                        
                    }}})
                }
                let firstName = object.object(forKey: USER_FIRST_NAME) as? String
                let lastName = object.object(forKey: USER_LAST_NAME) as? String
                cell.nameLabel.text = "\(firstName!) \(lastName!)"
        
        return cell
    }
    
    func loadPlayer() {
        
        query.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        query.whereKey("player", containedIn: [PFUser.current()!])
        query.includeKey("player")
        query.order(byAscending: UPDATEDAT)
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                for o in objects! {
                    if let pointerObjects = o["player"]! as? [PFUser] {
                        for object in pointerObjects {
                            if self.playerList.contains(object){
                                self.playerList.append(object)
                            }
                        }
                        self.playerList = pointerObjects
                        print("player: \(self.playerList.count)")
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
