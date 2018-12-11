//
//  PrivateGameDetail.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/29/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Social
import EventKitUI

class PrivateGameDetail: UIViewController, UIGestureRecognizerDelegate {
    
    var rightBarButton: UIBarButtonItem!
    var objectId = ""
    var eventDetail = [PFObject]()
    var gameCreatedBy = ""
    var playerList: [PFUser]! = []
    
    var startDate = Date()
    var endDate = Date()
    var gameTitle = String()
    var descriptions = String()
    var location = String()
    
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
        image.layer.cornerRadius = 30
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
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
    
    var openProfileTap: UITapGestureRecognizer = UITapGestureRecognizer()
    var openMapTab: UITapGestureRecognizer = UITapGestureRecognizer()
    var saveToCalenderTap: UITapGestureRecognizer = UITapGestureRecognizer()
    var userObjectId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this Games Detail view and this objectId \(objectId)")
        view.backgroundColor = .clear
        addViews()
        openProfileTap.delegate = self
        openProfileTap = UITapGestureRecognizer(target: self, action: #selector(profilePreview))
        userImage.addGestureRecognizer(openProfileTap)
        userImage.isUserInteractionEnabled = true
        
        openMapTab.delegate = self
        openMapTab = UITapGestureRecognizer(target: self, action: #selector(openOnMap))
        locationStackView.addGestureRecognizer(openMapTab)
        locationStackView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGameDetail()
    }
    
    func loadGameDetail(){
        let query = PFQuery(className: EVENT_CLASS_NAME)
        query.whereKey(EVENT_OBJECT_ID, equalTo: objectId)
        query.includeKey(GAME_CREATED_BY)
        query.getObjectInBackground(withId: objectId) { (object, error) in
            if error == nil {
                let object = object
                let eventTime = "\(object?.object(forKey: GAME_START_TIME) ?? " ")"
                print("Event Time and date \(eventTime)")
                self.dateLabel.text = eventTime.replacingOccurrences(of: "\n", with: ", ")
                
                self.startDate = object?.object(forKey: "gameStartTime") as! Date
                self.endDate = object?.object(forKey: "gameEndTime") as! Date
                
                self.saveToCalenderTap = UITapGestureRecognizer(target: self, action: #selector(self.addEventToCalendar))
                self.dateLabel.addGestureRecognizer(self.saveToCalenderTap)
                self.dateLabel.isUserInteractionEnabled = true
                
                if let commentUser = object![GAME_CREATED_BY] as? PFUser {
                    let profilePicture = commentUser[USER_AVATAR] as? PFFile
                    if profilePicture != nil {
                        profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                            if error == nil {
                                if let imageData = imageData {
                                    self.userImage.image = UIImage(data: imageData)
                                }}})
                        
                        
                    }
                    self.userObjectId = commentUser.objectId!
                    let firstName = commentUser.object(forKey: USER_FIRST_NAME) as? String
                    let lastName = commentUser.object(forKey: USER_LAST_NAME) as? String
                    self.userNameLabel.text = "Organized by \(firstName!) \(lastName!)"
                    print(self.userNameLabel.text!)
                }
                
                self.gameNameLabel.text = object?.object(forKey: GAME_TEAM_NAME) as? String
                self.imageView.file = object?.object(forKey: EVENT_IMAGE) as? PFFile
                self.skillLabel.text = object?.object(forKey: GAME_SKILL_LEVEL) as? String
                self.locationLabel.text = object?.object(forKey: GAME_LOCATION_NAME) as? String
                self.priceLabel.text = object?.object(forKey: GAME_PIRCE) as? String
                
            }
        }
    }
    
    @objc func profilePreview(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
        vc.objectId = userObjectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openOnMap(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowLocationOnMap") as! ShowLocationOnMap
        vc.objectId = objectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    let eventStore = EKEventStore()
    var event_id = ""
    @objc func addEventToCalendar() {
        var eventAlreadyExists = false
        eventStore.requestAccess( to: EKEntityType.event, completion:{(granted, error) in
            DispatchQueue.main.async {
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: self.eventStore)
                    event.title = "My Event"
                    event.startDate = Date(timeInterval: TimeInterval(), since: self.startDate)
                    event.endDate = Date(timeInterval: TimeInterval(), since: self.endDate)
                    event.location = self.location
                    let predicate = self.eventStore.predicateForEvents(withStart: self.startDate, end: self.endDate, calendars: nil)
                    
                    let existingEvents = self.eventStore.events(matching: predicate)
                    for singleEvent in existingEvents {
                        if singleEvent.title == event.title && singleEvent.startDate == self.startDate && singleEvent.endDate == self.endDate {
                            eventAlreadyExists = true
                            self.simpleAlert("Event Already Exists in Calendar")
                            break
                        }
                    }
                    
                    if !eventAlreadyExists {
                        let eventController = EKEventEditViewController()
                        eventController.event = event
                        eventController.eventStore = self.eventStore
                        eventController.editViewDelegate = self
                        self.present(eventController, animated: true, completion: nil)
                    }
                }
            }
        })
    }
    
}

extension PrivateGameDetail{
    
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
        
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        statesLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 15).isActive = true
        statesLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        gameNameLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        gameNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        gameNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        userImage.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 20).isActive = true
        userImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
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
        
        bottomSeparatorView.topAnchor.constraint(equalTo: skillImage.bottomAnchor, constant: 25).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
}

extension PrivateGameDetail: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
