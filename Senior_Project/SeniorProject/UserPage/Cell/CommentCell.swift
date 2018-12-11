//
//  CommentCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/12/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import ParseUI
import MapKit

class CommentCell: UICollectionViewCell {
    
    var msgView: UIView!
    var msgBalView: UIImageView!
    
    var profileImage: UIImageView! = UIImageView()
    var messageTime: UILabel! = UILabel()
    var messageText: UILabel! = UILabel()
    var sentBy: Bool! = Bool()
    var textMarginHorizontal: CGFloat = 15.5
    var textMarginVertical: CGFloat = 7.5
    var messageTextSize: CGFloat = 14.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    class func maxTextWidth() -> CGFloat {
        if UI_USER_INTERFACE_IDIOM() == .phone {
            return 220.0
        }
        else {
            return 400.0
        }
    }
    
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func balloonImage(_ sent: Bool) -> UIImage {
        if sent == true {
//            return CommentCell.imageWithColor(deepPurple)
            return CommentCell.imageWithColor(UIColor(red: 200/255, green: 230/255, blue: 201/255, alpha: 1.0));
            
        }
        else {
            return CommentCell.imageWithColor(viewBackgroundColore)
//            return CommentCell.imageWithColor(UIColor(red: 232/255, green: 245/255, blue: 233/255, alpha: 1.0));
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.msgView = UIView(frame: CGRect.zero)
        self.msgView.autoresizingMask = .flexibleHeight
        self.msgBalView = UIImageView(frame: CGRect.zero)
        self.messageText = UILabel(frame: CGRect.zero)
        self.messageTime = UILabel(frame: CGRect.zero)
        self.profileImage = UIImageView(image: nil)
        self.messageText.backgroundColor = UIColor.clear
        self.messageText.font = UIFont.systemFont(ofSize: messageTextSize)
        self.messageText.lineBreakMode = .byWordWrapping
        self.messageText.numberOfLines = 0
        self.messageTime.font = UIFont.boldSystemFont(ofSize: 10.0)
        self.messageTime.textColor = UIColor.darkGray
        self.messageTime.backgroundColor = UIColor.clear
        self.msgView.addSubview(self.msgBalView)
        self.msgView.addSubview(self.messageText)
        self.contentView.addSubview(self.messageTime)
        self.contentView.addSubview(self.msgView)
        self.contentView.addSubview(self.profileImage)
    }
    
    required  init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func floatVertical () -> CGFloat  {
        return textMarginVertical
    }
    func floatHorizontal () -> CGFloat  {
        return textMarginHorizontal
    }
    
    func messageSize1(_ message: NSString) -> CGSize {
        
        let a = message.boundingRect(with: CGSize(width: CommentCell.maxTextWidth(), height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font :messageText.font], context: nil)
        
        return a.size
    }
    
    override func layoutSubviews() {
        
        let textSize: CGSize = self.messageSize1(messageText.text! as NSString)
        let b = messageTime.text!._bridgeToObjectiveC().boundingRect(with: messageTime.frame.size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font :messageTime.font], context: nil)
        let timeSize: CGSize = b.size
        
        var msgBalViewFrame: CGRect = CGRect.zero
        var messageTextFrame: CGRect = CGRect.zero
        var messageTimeFrame: CGRect = CGRect.zero
        var profileImageFrame: CGRect = CGRect.zero
//        timeSize.width
        messageTimeFrame = CGRect(x: textMarginHorizontal + 30, y: 0.0, width: 300, height: timeSize.height)
        msgBalViewFrame = CGRect(x: 0.0 + 35, y: messageTimeFrame.size.height+2, width: textSize.width + 2 * self.textMarginHorizontal, height: textSize.height + 2 * self.textMarginVertical)
        messageTextFrame = CGRect(x: textMarginHorizontal + 32, y: msgBalViewFrame.origin.y + self.textMarginVertical, width: textSize.width, height: textSize.height)
        profileImageFrame = CGRect(x: 4, y: messageTimeFrame.size.height+msgBalViewFrame.height/2-timeSize.height, width: 36.0, height: 36.0)
        
        self.msgBalView.image = CommentCell.balloonImage(sentBy)
        self.msgBalView.frame = msgBalViewFrame
        self.messageText.frame = messageTextFrame
        if self.profileImage.image != nil {
            self.profileImage.frame = profileImageFrame
            profileImage.layer.cornerRadius = profileImage.frame.size.width/2
            profileImage.layer.masksToBounds=true
        }
        if self.messageTime.text != nil {
            self.messageTime.frame = messageTimeFrame
        }
    }
}
