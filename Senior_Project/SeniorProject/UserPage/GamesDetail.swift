//
//  GoingGamesCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/21/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Social
import EventKitUI

class GamesDetail: UIViewController, UIGestureRecognizerDelegate {
    
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
    
    let spotLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "5 spot left"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var rightBarButton: UIBarButtonItem!
    var objectId = ""
    var eventDetail = [PFObject]()
    var gameCreatedBy = ""
    var userObjectId = ""
    var openProfileTap: UITapGestureRecognizer = UITapGestureRecognizer()
    var openMapTab: UITapGestureRecognizer = UITapGestureRecognizer()
    var saveToCalenderTap: UITapGestureRecognizer = UITapGestureRecognizer()
    let query = PFQuery(className: EVENT_CLASS_NAME)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("this Games Detail view and this objectId \(objectId)")
        view.backgroundColor = .clear
        openProfileTap.delegate = self
        openProfileTap = UITapGestureRecognizer(target: self, action: #selector(profilePreview))
        userImage.addGestureRecognizer(openProfileTap)
        userImage.isUserInteractionEnabled = true
        
        openMapTab.delegate = self
        openMapTab = UITapGestureRecognizer(target: self, action: #selector(openOnMap))
        locationStackView.addGestureRecognizer(openMapTab)
        locationStackView.isUserInteractionEnabled = true
        
        addViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadGameDetail()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        query.cancel()
        
    }
    @objc func profilePreview(){
        
        DispatchQueue.main.async {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileView") as! ProfileView
            viewController.objectId = self.userObjectId
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func newEvent(_ sender: Any) {
        DispatchQueue.main.async {
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newEvent") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
    @objc func openOnMap(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ShowLocationOnMap") as! ShowLocationOnMap
        vc.objectId = objectId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    var startDate = Date()
    var endDate = Date()
    var gameTitle = String()
    var descriptions = String()
    var location = String()
    
    func loadGameDetail(){
        
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
                let join = object?.object(forKey: JOINED) as? Int
                let count = object?.object(forKey: COUNTS) as? Int
                let left = count! - join!
                self.spotLabel.text = "\(join!) Going  \(left) Spot left"
                
                if let commentUser = object![GAME_CREATED_BY] as? PFUser {
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
                
                
                self.imageView.file = object?.object(forKey: EVENT_IMAGE) as? PFFile
                self.skillLabel.text = object?.object(forKey: GAME_SKILL_LEVEL) as? String
                self.locationLabel.text = object?.object(forKey: GAME_LOCATION_NAME) as? String
                self.priceLabel.text = object?.object(forKey: GAME_PIRCE) as? String
                self.location = object?.object(forKey: GAME_LOCATION_NAME) as! String
            }
        }
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

extension GamesDetail{
    
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
        
        bottomSeparatorView.topAnchor.constraint(equalTo: parentStackView.bottomAnchor, constant: 10).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        spotLabel.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 20).isActive = true
        spotLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        spotLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
    }
}

extension GamesDetail: EKEventEditViewDelegate {
    
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true, completion: nil)
    }
}
