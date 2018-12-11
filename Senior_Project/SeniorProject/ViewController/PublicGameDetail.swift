//
//  PublicGameDetail.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/24/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Foundation
import UIKit
import ParseUI

class PublicGameDetail: UIViewController, UIGestureRecognizerDelegate{
    
    var objectId = ""
    var eventDetail = [PFObject]()
    var gameCreatedBy = ""
    
    let imageView: PFImageView = {
        let image = PFImageView()
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.image = UIImage(named: "GameImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let statesLabel: UILabel = {
        let label = UILabel()
        label.autoSetDimension(.height, toSize: 30)
        label.autoSetDimension(.width, toSize: 100)
        label.text = "PAST"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor(red:0.96, green:0.35, blue:0.44, alpha:1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Nov 30,2018, 2:15 PM"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gameNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Fontbonne Student"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "GameImage")
        image.layer.cornerRadius = 40
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Zakaria Alsahfi"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = deepPurple
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let skillImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "skill")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "All Skill Levels"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let locationImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "place-marker")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Fontbonne Univercity"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "ticket")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "$20"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let parentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.backgroundColor = .white
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let skillStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = .green
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let locationStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = UIColor.yellow
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let priceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = .gray
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let spotLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "5 spot left"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let joineButton: UIButton = {
        let button = UIButton()
        button.setTitle("JOIN", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = deepPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var EventObject = PFObject(className: EVENT_CLASS_NAME)
    var rightBarButton: UIBarButtonItem!
    var openProfileTap: UITapGestureRecognizer = UITapGestureRecognizer()
    var userObjectId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = deepPurple
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.title = "Game Info"
        view.backgroundColor = .white
        
        openProfileTap.delegate = self
        openProfileTap = UITapGestureRecognizer(target: self, action: #selector(profilePreview))
        userImage.addGestureRecognizer(openProfileTap)
        userImage.isUserInteractionEnabled = true
        
        joineButton.addTarget(self, action: #selector(JoinbuttonClicked(sender:)), for: .touchUpInside)
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationItem.backBarButtonItem?.tintColor = .white
        loadGameDetail()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }
    
    @objc func profilePreview(){
        DispatchQueue.main.async {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
            viewController.objectId = self.userObjectId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func loadGameDetail(){
        let query = PFQuery(className: EVENT_CLASS_NAME)
        query.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        query.includeKey(GAME_CREATED_BY)
        query.getObjectInBackground(withId: objectId) { (object, error) in
            if error == nil {
                self.EventObject = object!
                let count = self.EventObject.object(forKey: COUNTS) as? Int
                let joined = self.EventObject.object(forKey: JOINED) as? Int
                let spotLeft = count! - joined!
                if spotLeft == count! {
                    self.spotLabel.textAlignment = .center
                     self.spotLabel.text = "No one Joined yet\nBe the first to Join in this game"
                }else if spotLeft == 0 {
                    self.spotLabel.textColor = .red
                    self.spotLabel.font = UIFont.boldSystemFont(ofSize: 20)
                    self.spotLabel.textAlignment = .center
                    self.spotLabel.text = "all Spots are Booked"
                    self.rightBarButton.isEnabled = false
                }else {
                    self.spotLabel.textColor = deepPurple
                    self.spotLabel.textAlignment = .center
                    self.spotLabel.text = "\(joined!) Joined  \(spotLeft) Spot left"
                }
                
                print(spotLeft)
                let eventTime = "\(self.EventObject.object(forKey: GAME_START_TIME) ?? " ")"
                print("Event Time and date \(eventTime)")
                self.dateLabel.text = eventTime.replacingOccurrences(of: "\n", with: ", ")
                
                
                if let commentUser = self.EventObject[GAME_CREATED_BY] as? PFUser {
                    let profilePicture = commentUser[USER_AVATAR] as? PFFile
                    if profilePicture != nil {
                        profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    self.userImage.image = UIImage(data: imageData)
                                }}})
                        
                        
                    }
                    let objectId = commentUser.objectId
                    self.userObjectId = objectId!
                    let firstName = commentUser.object(forKey: USER_FIRST_NAME) as? String
                    let lastName = commentUser.object(forKey: USER_LAST_NAME) as? String
                    self.userNameLabel.text = "Organized by \(firstName!) \(lastName!)"
                    print(self.userNameLabel.text!)
                }
                
                
                self.imageView.file = self.EventObject.object(forKey: EVENT_IMAGE) as? PFFile
                self.skillLabel.text = self.EventObject.object(forKey: GAME_SKILL_LEVEL) as? String
                self.locationLabel.text = self.EventObject.object(forKey: GAME_LOCATION_NAME) as? String
                self.priceLabel.text = self.EventObject.object(forKey: GAME_PIRCE) as? String
            }else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    @objc func JoinbuttonClicked(sender:UIButton) {
        
        let query = PFQuery(className: EVENT_CLASS_NAME)
        query.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        query.includeKey("player")
        query.getObjectInBackground(withId: objectId) { (object, error) in
            if error == nil {
                self.EventObject = object!
            }
        }
        sender.isEnabled = false
        let myObjectID = EventObject.objectId
        print(myObjectID ?? " ")
        EventObject.addObjects(from: [PFUser.current()!], forKey: "player")
        EventObject.incrementKey(JOINED, byAmount: 1)
        EventObject.saveInBackground()
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PublicGameDetail{
    
    func addViews(){
        
        view.addSubview(imageView)
        view.addSubview(statesLabel)
        view.bringSubviewToFront(statesLabel)
        view.addSubview(dateLabel)
        view.addSubview(gameNameLabel)
        view.addSubview(userImage)
        view.addSubview(userNameLabel)
        view.addSubview(topSeparatorView)
        
        view.addSubview(skillImage)
        view.addSubview(skillLabel)
        view.addSubview(skillStackView)
        
        view.addSubview(locationImage)
        view.addSubview(locationLabel)
        view.addSubview(locationStackView)
        
        view.addSubview(priceImage)
        view.addSubview(priceLabel)
        view.addSubview(priceStackView)
        
        view.addSubview(parentStackView)
        
        view.addSubview(bottomSeparatorView)
        view.addSubview(spotLabel)
        view.addSubview(joineButton)
        
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        statesLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 15).isActive = true
        statesLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        gameNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10).isActive = true
        gameNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        gameNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gameNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        userImage.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 20).isActive = true
        userImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        userNameLabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 10).isActive = true
        userNameLabel.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
        userNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        topSeparatorView.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 10).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        skillStackView.addArrangedSubview(skillImage)
        skillImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        skillStackView.addArrangedSubview(skillLabel)
        
        locationStackView.addArrangedSubview(locationImage)
        locationImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        locationStackView.addArrangedSubview(locationLabel)
        
        priceStackView.addArrangedSubview(priceImage)
        priceImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        priceStackView.addArrangedSubview(priceLabel)
        
        parentStackView.addArrangedSubview(skillStackView)
        parentStackView.addArrangedSubview(locationStackView)
        parentStackView.addArrangedSubview(priceStackView)
        
        parentStackView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 10).isActive = true
        parentStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        parentStackView.widthAnchor.constraint(equalToConstant: 330).isActive = true
        parentStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        bottomSeparatorView.topAnchor.constraint(equalTo: skillLabel.bottomAnchor, constant: 10).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        spotLabel.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 20).isActive = true
        spotLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        spotLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        joineButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        joineButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        joineButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        joineButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
}
