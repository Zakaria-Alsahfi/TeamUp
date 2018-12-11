//
//  Messages.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/8/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Parse

class Messages {
    
    class func startPrivateChat(user1: PFUser, user2: PFUser) -> String {
        let id1 = user1.objectId
        let id2 = user2.objectId
        
        let groupId = (id1! < id2!) ? "\(String(describing: id1))\(String(describing: id2))" : "\(String(describing: id2))\(String(describing: id1))"
        
        createMessageItem(user: user1, groupId: groupId, description: user2[PF_USER_USERNAME] as! String)
        createMessageItem(user: user2, groupId: groupId, description: user1[PF_USER_USERNAME] as! String)
        
        return groupId
    }
    
    class func createMessageItem(user: PFUser, groupId: String, description: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_USER, equalTo: user)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                if objects!.count == 0 {
                    let message = PFObject(className: PF_MESSAGES_CLASS_NAME)
                    message[PF_MESSAGES_USER] = user;
                    message[PF_MESSAGES_GROUPID] = groupId;
                    message[PF_MESSAGES_DESCRIPTION] = description;
                    message[PF_MESSAGES_LASTUSER] = PFUser.current()
                    message[PF_MESSAGES_LASTMESSAGE] = "";
                    message[PF_MESSAGES_COUNTER] = 0
                    message[PF_MESSAGES_UPDATEDACTION] = NSDate()
                    message.saveInBackground(block: { (succeeded, error) -> Void in
                        if (error != nil) {
                            print("Messages.createMessageItem save error.")
                            print(error as Any)
                        }
                    })
                }
            } else {
                print("Messages.createMessageItem save error.")
                print(error as Any)
            }
        }
    }
    
    class func deleteMessageItem(message: PFObject) {
        message.deleteInBackground { (succeeded, error) -> Void in
            if error != nil {
                print("UpdateMessageCounter save error.")
                print(error as Any)
            }
        }
    }
    
    class func updateMessageCounter(groupId: String, lastMessage: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.limit = 1000
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for message in objects! {
                    let user = message[PF_MESSAGES_USER] as! PFUser
                    if user.objectId != PFUser.current()!.objectId {
                        message.incrementKey(PF_MESSAGES_COUNTER) // Increment by 1
                        message[PF_MESSAGES_LASTUSER] = PFUser.current()
                        message[PF_MESSAGES_LASTMESSAGE] = lastMessage
                        message[PF_MESSAGES_UPDATEDACTION] = NSDate()
                        message.saveInBackground(block: { (succeeded, error) -> Void in
                            if error != nil {
                                print("UpdateMessageCounter save error.")
                                print(error as Any)
                            }
                        })
                    }
                }
            } else {
                print("UpdateMessageCounter save error.")
                print(error as Any)
            }
        }
    }
    
    class func clearMessageCounter(groupId: String) {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_GROUPID, equalTo: groupId)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()!)
        query.findObjectsInBackground { (objects, error) -> Void in
            if error == nil {
                for message in objects! {
                    message[PF_MESSAGES_COUNTER] = 0
                    message.saveInBackground(block: { (succeeded, error) -> Void in
                        if error != nil {
                            print("ClearMessageCounter save error.")
                            print(error as Any)
                        }
                    })
                }
            } else {
                print("ClearMessageCounter save error.")
                print(error as Any)
            }
        }
    }
}

