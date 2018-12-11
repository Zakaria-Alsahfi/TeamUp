//
//  FriendsListCVC.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 6/3/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import Contacts
import ProgressHUD

class FriendsListCVC: UIViewController {
    
    let reuseIdentifier = "CellID"
    let query = PFQuery(className: "_User")
    var users = [PFUser]()
    var currentUser = PFUser.current()!
    var userLocation = PFGeoPoint()
    var distance = 0
    var aUser: PFUser = PFUser()
    
    var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .blue
        return refresh
    }()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    var searchbar: UISearchBar = {
        let search = UISearchBar()
        search.placeholder = "Search By Name "
        search.tintColor = deepPurple
        search.barTintColor = viewBackgroundColore
        search.sizeToFit()
        search.showsCancelButton = true
        search.translatesAutoresizingMaskIntoConstraints = false
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        setUpViews()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    
    
    func setUpViews(){
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FriendListCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        
        searchbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: searchbar.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = " "
        query.cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentUser.fetchIfNeededInBackground(block: { (user, error) in
            if error == nil && user != nil {
                self.distance = user?.object(forKey: "distance") as! Int
                self.userLocation = user?.object(forKey: "location") as! PFGeoPoint
                var Userlocality = ""
                var Userstate = ""
                let geoCoder = CLGeocoder()
                let location = CLLocation(latitude: self.userLocation.latitude, longitude: self.userLocation.longitude)
                geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                    var placeMark: CLPlacemark!
                    placeMark = placemarks?[0]
                    if placeMark != nil {
                        // locality
                        if let locality = placeMark.locality {
                            Userlocality = locality
                            print(locality)
                        }
                        // state
                        if let state = placeMark.administrativeArea {
                            Userstate = state
                            print(state)
                        }
                        self.navigationItem.title = "\(Userlocality), \(Userstate)"
                    }
                }
            }else {
                ProgressHUD.showError("Network error")
            }
        })
        
        fetchUsers()
    }
    
    @objc func loadData(){
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    @objc func sendMessage(){
        let user1 = PFUser.current()!
        let groupId = Messages.startPrivateChat(user1: user1, user2: aUser)
        self.openChat(groupId: groupId)
    }
    func openChat(groupId: String) {
        self.performSegue(withIdentifier: "messagesChat", sender: groupId)
    }
    
    // MARK: - Prepare for segue to chatVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
    }
    
    func fetchUsers() {
        let objectId = PFUser.current()?.objectId
        query.whereKey("objectId", notEqualTo: objectId as Any)
        query.whereKey("location", nearGeoPoint: userLocation, withinMiles: Double(distance))
        query.order(byAscending: "username")
        query.findObjectsInBackground { (user, error) in
            if error == nil {
                self.users = user as! [PFUser]
                self.collectionView.reloadData()
            }else{
                print(error as Any)
            }
        }
    }
    
    func searchUsers(searchText: String) {
        self.users.removeAll(keepingCapacity: true)
        let firstQuery = PFUser.query()!
        firstQuery.whereKey(USER_FIRST_NAME, equalTo: searchText)
        
        let secQuery = PFUser.query()!
        secQuery.whereKey(USER_LAST_NAME, equalTo: searchText)
        
        let orQuery = PFQuery.orQuery(withSubqueries: [firstQuery, secQuery])
        orQuery.findObjectsInBackground { (user, error) -> Void in
            if !(error != nil) {
                // The find succeeded.
                print("succesfull load Users")
                // Do something with the found objects
                for user  in user! {
                    self.users.append(user as! PFUser)
                    print("users added to userlist")
                }
                self.collectionView.reloadData()
            } else {
                // Log details of the failure
                print("error loadind user ")
                print("error")
            }
            
        }
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
}


extension FriendsListCVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendListCell
       aUser = self.users[indexPath.row]
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
        cell.messageButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionViewLayout.collectionView?.needsUpdateConstraints()
        return 10
    }
}


extension FriendsListCVC: UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        fetchUsers()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            searchUsers(searchText: searchText)
        }else {
            fetchUsers()
        }
        
    }
}
