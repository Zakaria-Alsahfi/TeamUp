//
//  ProfileView.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/29/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//
import UIKit
import Parse

class ProfileView: UIViewController, UINavigationControllerDelegate {
    
    var objectId = ""
    var total = 0
    var leftBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = deepPurple
        self.navigationController?.navigationBar.tintColor = .white
        
        self.addSubviews()
        self.getUserData()
        self.numberOfHostedGame()
        self.numberOfAttendedGame()
    }
    
    func getUserData(){
        let User = PFUser.query()
        User?.whereKey("objectId", equalTo: objectId)
        User?.getFirstObjectInBackground(block: { (user, error) in
            if error == nil {
                let user = user as? PFUser
                let firstName = user!.object(forKey: USER_FIRST_NAME) as? String
                let lastName = user!.object(forKey: USER_LAST_NAME) as? String
                self.title = "\(firstName!) \(lastName!)"
                
                let imageFile = user!.value(forKey: USER_AVATAR) as? PFFile
                if imageFile != nil {
                    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.avatar.image = self.avatar.image?.circle
                                self.avatar.image = UIImage(data:imageData)
                                
                            }}})
                }
            }
        })
    }
    
    func numberOfHostedGame(){
        let query = PFQuery(className: EVENT_CLASS_NAME)
        var hostedGame = [PFObject]()
        query.whereKey("user", equalTo: PFUser.current()!.username!)
        query.includeKey(REVIEW_COMMENTBY)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                hostedGame.removeAll(keepingCapacity: false)
                hostedGame += objects!
                self.total = hostedGame.count
                if self.total > 0 {
                    self.hosteLabel.text = "\(self.total) Games orgnaized"
                }else {
                    self.hosteLabel.text = "\(self.total) Game orgnaized"
                }
                print(self.total)
            }else {
                self.showHUD("Network error")
            }
        }
        
    }
    
    func numberOfAttendedGame(){
        let query = PFQuery(className: EVENT_CLASS_NAME)
        var attendedGame = [PFObject]()
        query.whereKey("player", containedIn: [PFUser.current()!])
        query.includeKey(REVIEW_COMMENTBY)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                attendedGame.removeAll(keepingCapacity: false)
                attendedGame += objects!
                self.total = attendedGame.count
                if self.total > 0 {
                    self.attendedLabel.text = "\(self.total) Games attended"
                }else {
                    self.attendedLabel.text = "\(self.total) Game attended"
                }
                print(self.total)
            }else {
                self.showHUD("Network error")
            }
        }
    }
    
    let upperView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let attendedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0 Games attended"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hosteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0 Games orgnaized"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    func addSubviews() {
        
        view.addSubview(upperView)
        upperView.setUserCellShadow()
        upperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        upperView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        upperView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        upperView.addSubview(avatar)
        upperView.addSubview(hosteLabel)
        upperView.addSubview(attendedLabel)
        
        avatar.leftAnchor.constraint(equalTo: upperView.leftAnchor, constant: 10).isActive = true
        avatar.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 30).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        attendedLabel.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 30).isActive = true
        attendedLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 50).isActive = true
        attendedLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        hosteLabel.topAnchor.constraint(equalTo: attendedLabel.topAnchor, constant: 30).isActive = true
        hosteLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 50).isActive = true
        hosteLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
