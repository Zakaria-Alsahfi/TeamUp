//
//  MessagesCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/8/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import JSQMessagesViewController

class MessagesCell: UITableViewCell {
    
    @IBOutlet var userImage: PFImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var counterLabel: UILabel!
    
    func bindData(message: PFObject) {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
        userImage.layer.masksToBounds = true
        
        let lastUser = message[PF_MESSAGES_LASTUSER] as? PFUser
        userImage.file = lastUser?[PF_USER_PICTURE] as? PFFile
        userImage.loadInBackground()
        
        descriptionLabel.text = message[PF_MESSAGES_DESCRIPTION] as? String
        lastMessageLabel.text = message[PF_MESSAGES_LASTMESSAGE] as? String
        
        let seconds = NSDate().timeIntervalSince(message[PF_MESSAGES_UPDATEDACTION] as! Date)
        timeElapsedLabel.text = Utilities.timeElapsed(seconds: seconds)
        let dateText = JSQMessagesTimestampFormatter.shared().relativeDate(for: message[PF_MESSAGES_UPDATEDACTION] as? Date)
        if dateText == "Today" {
            timeElapsedLabel.text = JSQMessagesTimestampFormatter.shared().time(for: message[PF_MESSAGES_UPDATEDACTION] as? Date)
        } else {
            timeElapsedLabel.text = dateText
        }
        
        let counter = (message[PF_MESSAGES_COUNTER]! as AnyObject).integerValue!
        counterLabel.text = (counter == 0) ? "" : "\(counter) new"
    }
}

