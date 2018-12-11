//
//  NewTeam.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/19/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//
import UIKit
import Parse

protocol SelectTeamDelegate {
    func didSelectTeam(selectedTeam: [PFUser]!)
}

class NewTeam: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    var selection = [String]()
    let currentUser = PFUser.current()!
    var delegate: SelectTeamDelegate!
    
    let reuseIdentifier = "CellID"
    var collectionView: UICollectionView!
    let query = PFQuery(className: "_User")
    var users = [PFUser]()
    
    var refreshControl:UIRefreshControl!
    var rightBarButton: UIBarButtonItem!
    var leftBarButton: UIBarButtonItem!
    
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    var locality = ""
    var locationName = ""
    var price = ""
    var startTime = ""
    var endTime = ""
    var skilllevel = ""
    
    var userLocation = PFGeoPoint()
    var distance = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup the bar button
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Invite Player"
        
        self.rightBarButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextPage))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.rightBarButton.isEnabled = false
        self.rightBarButton.tintColor = .white
        
        self.leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        self.leftBarButton.tintColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView?.register(Friend.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = .clear
        collectionView?.alwaysBounceVertical = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        collectionView.allowsMultipleSelection = true
        collectionView.allowsSelection = true
        
        print("\(address)\n\(price)\n\(skilllevel)\n\(startTime)\n\(endTime)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selection.removeAll(keepingCapacity: false)
        currentUser.fetchIfNeededInBackground(block: { (user, error) in
            if error == nil && user != nil {
                self.distance = user?.object(forKey: "distance") as! Int
                self.userLocation = user?.object(forKey: "location") as! PFGeoPoint
            }
        })
        
        self.loadUsers()
    }
    
    @objc func loadData(){
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func nextPage(){
        let vc = TeamNextPage()
        var selectedUsers = [PFUser]()
        for user in self.users {
            if self.selection.contains(user.objectId!){
                selectedUsers.append(user)
                vc.teamMembers = selectedUsers
                vc.address = address
                vc.locationName = locationName
                vc.longitude = longitude
                vc.latitude = latitude
                vc.locality = locality
                vc.price = price
                vc.startTime = startTime
                vc.endTime = endTime
                vc.skilllevel = skilllevel
                
            }
            
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Backend methods
    
    func loadUsers() {
        
        query.whereKey(PF_USER_OBJECTID, notEqualTo: currentUser.objectId!)
        query.whereKey("location", nearGeoPoint: userLocation, withinMiles: Double(distance))
        query.order(byAscending: PF_USER_USERNAME)
        query.findObjectsInBackground { (user, error) in
            if error == nil {
                self.users = user as! [PFUser]
                self.collectionView?.reloadData()
            }else{
                self.showHUD("Network error")
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! Friend
        
        let user = self.users[indexPath.row]
        let firstName = user.object(forKey: USER_FIRST_NAME) as? String
        let lastName = user.object(forKey: USER_LAST_NAME) as? String
        cell.nameLabel.text = "\(firstName!) \(lastName!)"
        
        let imageFile = user[USER_AVATAR] as? PFFile
        if imageFile != nil {
            imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.profileImage.image = UIImage(data:imageData)
                        
                    }}})
            
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let user = self.users[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! Friend
        cell.checkmarkButton.backgroundColor = deepPurple
        
        self.selection.append(user.objectId!)
        print(user.objectId!)
        if selection.count > 0 {
            self.rightBarButton.isEnabled = true
        }else {
            self.rightBarButton.isEnabled = false
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let user = self.users[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! Friend
        cell.checkmarkButton.backgroundColor = .white
        if let index = self.selection.index(of: user.objectId!) {
            self.selection.remove(at: index)
            print(user.objectId!)
        }
        if selection.count > 0 {
            self.rightBarButton.isEnabled = true
        }else {
            self.rightBarButton.isEnabled = false
        }
    }
}


class Friend: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.image = UIImage(named: "pall")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = deepPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let checkmarkButton: UIView = {
        let button = UIView()
        button.backgroundColor = .white
        button.layer.borderWidth = 8
        button.layer.borderColor = skillButtonColor
        button.layer.cornerRadius = 17.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addViews() {
        
        setUserCellShadow()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(checkmarkButton)
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        checkmarkButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        checkmarkButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        checkmarkButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        checkmarkButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        checkmarkButton.widthAnchor.constraint(equalToConstant: 35).isActive = true
    }
}
