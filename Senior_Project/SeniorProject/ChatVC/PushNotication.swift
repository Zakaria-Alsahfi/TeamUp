//
//  PushNotication.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/8/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Foundation
import Parse

class PushNotication {
    
    class func parsePushUserAssign() {
        let installation = PFInstallation.current()
        installation![PF_INSTALLATION_USER] = PFUser.current()
        installation?.saveInBackground { (succeeded, error) -> Void in
            if error != nil {
                print("parsePushUserAssign save error.")
            }
        }
    }
    
    class func parsePushUserResign() {
        let installation = PFInstallation.current()
        installation?.remove(forKey: PF_INSTALLATION_USER)
        installation?.saveInBackground { (succeeded, error) -> Void in
            if error != nil {
                print("parsePushUserResign save error")
            }
        }
    }
    
    class func sendPushNotification(groupId: String, text: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()!)
        query.includeKey(PF_MESSAGES_USER)
        query.limit = 1000
        
        let installationQuery = PFInstallation.query()
        installationQuery!.whereKey(PF_INSTALLATION_USER, matchesKey: PF_MESSAGES_USER, in: query)
        
        let push = PFPush()
        push.setQuery(installationQuery as? PFQuery<PFInstallation>)
        push.setMessage(text)
        push.sendInBackground { (succeeded, error) -> Void in
            if error != nil {
                print("sendPushNotification error")
            }
        }
    }
    class func sendPushGameNotification(groupId: [String]) {
        let query = PFQuery(className: EVENT_CLASS_NAME)
//        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_GROUPID, containedIn: [groupId])
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()?.username as Any)
        query.includeKey(PF_MESSAGES_USER)
        query.limit = 1000
        
        let installationQuery = PFInstallation.query()
        installationQuery!.whereKey(PF_INSTALLATION_USER, matchesKey: PF_MESSAGES_USER, in: query)
        
        let push = PFPush()
        push.setQuery(installationQuery as? PFQuery<PFInstallation>)
//        push.setMessage(text)
        push.sendInBackground { (succeeded, error) -> Void in
            if error != nil {
                print("sendPushNotification error")
            }
        }
    }
}
