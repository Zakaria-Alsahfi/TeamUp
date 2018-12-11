//
//  SelectSingleUser.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/22/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import Contacts


protocol SelectSingleDelegate {
    func didSelectSingleUser(user: PFUser)
}

class SelectSingleUser: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let reuseIdentifier = "CellID"
    var collectionView: UICollectionView!
    let query = PFQuery(className: "_User")
    var users = [PFUser]()
    var delegate: SelectSingleDelegate!
    var currentUser = PFUser.current()!
    
    var refreshControl:UIRefreshControl!
    var leftBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = deepPurple
        self.leftBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed(sender:)))
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        self.leftBarButton.tintColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let frame = CGRect(x: view.frame.origin.x, y: view.frame.origin.y, width: view.frame.size.width, height: view.frame.size.height - (tabBarController?.tabBar.frame.size.height ?? 0.0))
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        view.addSubview(collectionView!)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        
        // Register cell classes
        collectionView?.register(FriendCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.backgroundColor = viewBackgroundColore
        collectionView?.alwaysBounceVertical = true
        
        
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = .blue
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView?.addSubview(refreshControl)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchUsers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func loadData(){
        collectionView?.reloadData()
        refreshControl.endRefreshing()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
        
        let friend = self.users[indexPath.row]
        let firstName = friend.object(forKey: USER_FIRST_NAME) as? String
        let lastName = friend.object(forKey: USER_LAST_NAME) as? String
        cell.nameLabel.text = "\(firstName!) \(lastName!)"
        
        let imageFile = friend.value(forKey: USER_AVATAR) as? PFFile
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
        self.dismiss(animated: true, completion: { () -> Void in
            if self.delegate != nil {
                self.delegate.didSelectSingleUser(user: self.users[indexPath.row])
            }
        })
    }
    
    func fetchUsers() {
        let objectId = PFUser.current()?.objectId
        query.whereKey("objectId", notEqualTo: objectId as Any)
        query.whereKey("location", nearGeoPoint: PFUser.current()?.object(forKey: "location") as! PFGeoPoint, withinMiles: 50)
        query.order(byAscending: "username")
        query.findObjectsInBackground { (user, error) in
            if error == nil {
                self.users = user as! [PFUser]
                self.collectionView?.reloadData()
            }else{
                print(error as Any)
            }
        }
    }
    
    @objc func cancelButtonPressed(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

class FriendCell: UICollectionViewCell {
    
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
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addViews() {
        
        backgroundColor = .white
        self.setUserCellShadow()
        addSubview(profileImage)
        addSubview(nameLabel)
        
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
    }
}
