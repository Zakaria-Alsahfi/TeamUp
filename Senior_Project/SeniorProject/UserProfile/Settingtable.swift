//
//  Sittingtable.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/19/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Accounts
import MessageUI

class Settingtable: UITableViewController {
    
    let CGFLOAT_MIN = 0.000001
    var FacebookCell: UITableViewCell!
    var TwitterCell: UITableViewCell = UITableViewCell()
    var EditProfileCell: UITableViewCell = UITableViewCell()
    var LocationCell: UITableViewCell = UITableViewCell()
    var InviteFreinds: UITableViewCell = UITableViewCell()
    var LogOut: UITableViewCell = UITableViewCell()
    
    var Userstate = String()
    var Userlocality = String()
    let currentUser = PFUser.current()
    
    override func loadView() {
        super.loadView()
        tableView.alwaysBounceVertical = false
        tableView.backgroundColor = test
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        tableView.reloadData()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        var facebookAuthType: String!
        var twitterAuthType: String!
        
        
        if (currentUser?.isLinked(withAuthType: "facebook"))!{
            facebookAuthType = "Linked"
        }
        
        self.FacebookCell = UITableViewCell(style: .value1, reuseIdentifier: "FacebookCell")
        self.FacebookCell.textLabel?.text = "Facebook"
        self.FacebookCell.detailTextLabel?.text = facebookAuthType
        self.FacebookCell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        self.FacebookCell.backgroundColor = .white
        self.FacebookCell.accessoryType = UITableViewCell.AccessoryType.none
        
        if (currentUser?.isLinked(withAuthType: "twitter"))!{
            twitterAuthType = "Linked"
        }
        self.TwitterCell = UITableViewCell(style: .value1, reuseIdentifier: "TwitterCell")
        self.TwitterCell.textLabel?.text = "Twitter"
        self.TwitterCell.detailTextLabel?.text = twitterAuthType
        self.TwitterCell.backgroundColor = .white
        self.TwitterCell.accessoryType = UITableViewCell.AccessoryType.none
        
        self.EditProfileCell.textLabel?.text = "Edit Profile"
        self.EditProfileCell.backgroundColor = .white
        self.EditProfileCell.accessoryType = UITableViewCell.AccessoryType.none
        
        let Userlocation = currentUser?.object(forKey: "location") as? PFGeoPoint
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: (Userlocation?.latitude)!, longitude: (Userlocation?.longitude)!)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            self.Userlocality = placeMark.locality!
            self.Userstate = placeMark.administrativeArea!
            print("\(self.Userlocality),\(self.Userstate)")
            
            // Street address
            if let street = placeMark.thoroughfare {
                print(street)
            }
            // City
            if let city = placeMark.subAdministrativeArea {
                print(city)
            }
            // locality
            if let locality = placeMark.locality {
                self.Userlocality = locality
                print(locality)
            }
            // state
            if let state = placeMark.administrativeArea {
                self.Userstate = state
                print(state)
            }
            self.LocationCell.detailTextLabel?.text = "\(self.Userlocality), \(self.Userstate)"
        }
        
        self.LocationCell = UITableViewCell(style: .value1, reuseIdentifier: "LocationCell")
        self.LocationCell.textLabel?.text = "Location"
        self.LocationCell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
        self.LocationCell.backgroundColor = .white
        self.LocationCell.accessoryType = UITableViewCell.AccessoryType.none
        
        self.InviteFreinds.textLabel?.text = "Invite Freinds"
        self.InviteFreinds.backgroundColor = .white
        self.InviteFreinds.accessoryType = UITableViewCell.AccessoryType.none
        
        self.LogOut.textLabel?.text = "Log Out"
        self.LogOut.backgroundColor = .white
        self.LogOut.accessoryType = UITableViewCell.AccessoryType.none

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = " "
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Settings"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    // Return the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    // Return the number of rows for each section in your static table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2
        case 1: return 2
        case 2: return 1
        case 3: return 1
        default: fatalError("Unknown number of sections")
        }
    }
    
    // Return the row for the corresponding section and row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.FacebookCell
            case 1: return self.TwitterCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.EditProfileCell
            case 1: return self.LocationCell
            default: fatalError("Unknown row in section 0")
            }
        case 2:
            return self.InviteFreinds
        case 3:
            return self.LogOut
        default:
            fatalError("Unknown number of sections")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "LINKED SOCIAL ACCOUNTS"
        case 1: return "PREFERENCES"
        case 2: return "Share TeamUp"
        case 3: return ""
        default: fatalError("Unknown section")
        }
    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        view.tintColor = UIColor.yellow
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel!.textColor = .black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 || section == 1 || section == 2 || section == 3){
            return 50.0
        }else{
            return CGFloat(CGFLOAT_MIN);
        }
    }
    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: false)
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0:
                facebookAccount()
                print(indexPath.section == 0 && indexPath.row == 0)
            case 1:
                linkTwitter()
                print(indexPath.section == 0 && indexPath.row == 1)
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0:
                let vc = EditProfile()
                navigationController?.pushViewController(vc, animated: true)
                print(indexPath.section == 1 && indexPath.row == 0)
            case 1:
                let vc = MapVC()
                navigationController?.pushViewController(vc, animated: true)
                print(indexPath.section == 1 && indexPath.row == 1)
            default: fatalError("Unknown row in section 0")
            }
        case 2:
            tellAfriendButt()
            print(indexPath.section == 2 && indexPath.row == 0)
        case 3:
            logOut()
            print(indexPath.section == 3 && indexPath.row == 0)
        default:
            fatalError("Unknown number of sections")
        }
    }
    
}

extension Settingtable {

    func linkFacebook() {
        let user = PFUser.current()
        showHUD("linking")
        if !PFFacebookUtils.isLinked(with: user!) {
            PFFacebookUtils.linkUser(inBackground:  user!, withReadPermissions: nil, block:{
                (succeeded: Bool?, error) -> Void in
                if succeeded! {
                    self.hideHUD()
                    self.simpleAlert("Success. You can now log in using your facebook account in future.")
                }else if error != nil {
                    self.simpleAlert("\(error!.localizedDescription)")
                    self.hideHUD()
                    self.dismiss(animated: true, completion: nil)
                }else {
                    self.hideHUD()
                }
            })
        }
    }
    
    func unlinkFacebook() {
        let user = PFUser.current()
        showHUD("unlinking")
        PFFacebookUtils.unlinkUser(inBackground: user!, block:{
            (succeeded: Bool?, error) -> Void in
            if succeeded! {
                self.simpleAlert("Your account is no longer associated with your Facebook account.")
                self.hideHUD()
            }else{
                self.warningAlert("\(error!.localizedDescription)")
                self.hideHUD()
            }
        })
    }
    func facebookAccount(){
        let user = PFUser.current()
        if PFFacebookUtils.isLinked(with: user!){
            unlinkFacebook()
        }else {
            linkFacebook()
        }
    }
    func linkTwitter(){
        let user = PFUser.current()
        showHUD("linking")
        if !PFTwitterUtils.isLinked(with: user!){
            PFTwitterUtils.linkUser(user!) { (succeeded: Bool?, error) in
                if succeeded! {
                    self.warningAlert("Success. You can now log in using your Twitter account in future.")
                    self.hideHUD()
                }else{
                    self.warningAlert("\(error!.localizedDescription)")
                    self.hideHUD()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func tellAfriendButt() {
        let messageStr  = "Hi there, let's meet to play soccer on \(APP_NAME) | download it from the iTunes App Store: \(APPSTORE_LINK)"
        let img = UIImage(named: "soccer-background")!
        let shareItems = [messageStr, img] as [Any]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.print, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToVimeo]
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let popOver = UIPopoverController(contentViewController: activityViewController)
            popOver.present(from: CGRect.zero, in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
        } else {
            present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func logOut(){
        PFUser.logOut()
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewLoginPage") as! NewLoginPage
            let transition = CATransition()
            transition.duration = 0.0
            transition.type = .moveIn
            transition.subtype = .fromLeft
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
}


