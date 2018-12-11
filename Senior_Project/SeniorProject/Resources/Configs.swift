//
//  Configs.swift
//  teamup
//
//  Created by zakaria alsahfi on 4/19/18.
//


import Foundation
import UIKit
import AVFoundation
import EventKit

let APP_NAME = "TeamUp"
let PARSE_APP_ID = ""
let PARSE_CLIENT_KEY = ""
let APPSTORE_LINK = "https://fontbonne.edu/TeamUp/"
let deepPurple = UIColor(red: 74.0/255.0, green: 65.0/255.0, blue: 135.0/255.0, alpha: 1.0)
let broderColor = UIColor(red: 0.0588, green: 0.0784, blue: 0.0745, alpha: 1).cgColor
let labelColor = UIColor(red:0.27, green:0.26, blue:0.42, alpha:1.0).cgColor
let labelBackGroundColor = UIColor(red:0.22, green:0.20, blue:0.40, alpha:1.0)
let RECORD_MAX_DURATION:TimeInterval = 20
let viewBackgroundColore = UIColor(r: 242, g: 236, b: 246)
let labelTextColor = UIColor(red: 74.0/255.0, green: 65.0/255.0, blue: 135.0/255.0, alpha: 0.5)
let skillButtonColor = UIColor(r: 242, g: 236, b: 246).cgColor
let commentBackGroundColor = UIColor(red: 242/255, green: 236/255, blue: 246/255, alpha: 0.5)
let test = UIColor(r: 248, g: 248, b: 255)

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

let hudView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
let label = UILabel()
let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))

extension UIViewController {
    
    func showHUD(_ message:String) {
        hudView.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        hudView.backgroundColor = deepPurple
        hudView.alpha = 0.9
        hudView.layer.cornerRadius = 8
        
        indicatorView.center = CGPoint(x: hudView.frame.size.width/2, y: hudView.frame.size.height/2)
        indicatorView.style = UIActivityIndicatorView.Style.white
        hudView.addSubview(indicatorView)
        indicatorView.startAnimating()
        view.addSubview(hudView)
        
        label.frame = CGRect(x: 0, y: 90, width: 120, height: 20)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = message
        label.textAlignment = .center
        label.textColor = UIColor.white
        hudView.addSubview(label)
    }
    
    func hideHUD() {
        hudView.removeFromSuperview()
        label.removeFromSuperview()
    }
    
    func simpleAlert(_ mess:String) {
        let alert = UIAlertController(title: APP_NAME , message: mess, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func warningAlert(_ mess:String){
        let alert = UIAlertController(title: APP_NAME , message: mess, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}

let USER_CLASS_NAME                     = "User"
let USER_USERNAME                       = "username"
let USER_FIRST_NAME                     = "firstName"
let USER_LAST_NAME                      = "lastName"
let USER_PASSWORD                       = "password"
let USER_EMAIL                          = "email"
let USER_FULLNAME                       = "fullName"
let USER_AVATAR                         = "profileImage"
let USER_STATUS                         = "status"
let USER_PHONENUMBER                    = "phoneNumber"
let USER_OBJECTID                       = "objectId"
let EVENT_CLASS_NAME                    = "post"
let EVENT_LOCATION_NAME                 = "locationName"
let EVENT_OBJECT_ID                     = "objectId"
let EVENT_CITY                          = "city"
let EVENT_IMAGE                         = "eventImage"
let PRICE                               = "price"
let JOINED                              = "joined"
let LATITUDE                            = "latitude"
let LONGITUDE                           = "longitude"
let LOCATION                            = "location"
let CREATEDAT                           = "createdAt"
let UPDATEDAT                           = "updatedAt"
let COUNTS                              = "counts"
let USER_IMAGE                          = "userImage"
let USER_NAME                           = "user"
let PLACE_ATTRIBUTION                   = "placeAttribution"


let FAVORITES_CLASS_NAME                = "Favorites"
let FAVORITES_MESSAGE_POINTER           = "messagePointer"
let FAVORITES_USER_POINTER              = "userPointer"

let BLOCKED_CLASS_NAME                  = "Blocked"
let BLOCKED_A_USER                      = "aUser"
let BLOCKED_HAS_BLOCKED                 = "hasBlocked"


struct Constants {
    struct PF {
        struct Installation {
            static let ClassName = "_Installation"
        }
    }
}


/* Installation */
let PF_INSTALLATION_CLASS_NAME           = "Installation"           //    Class name
let PF_INSTALLATION_OBJECTID             = "objectId"                //    String
let PF_INSTALLATION_USER                 = "user"                    //    Pointer to User Class

/* User */
let PF_USER_CLASS_NAME                   = "User"                   //    Class name
let PF_USER_OBJECTID                     = "objectId"                //    String
let PF_USER_USERNAME                     = "username"                //    String
let PF_USER_PASSWORD                     = "password"                //    String
let PF_USER_EMAIL                        = "email"                   //    String
let PF_USER_EMAILCOPY                    = "emailCopy"               //    String
let PF_USER_FULLNAME_LOWER               = "fullname_lower"          //    String
let PF_USER_PICTURE                      = "profileImage"                 //    File
let PF_USER_THUMBNAIL                    = "thumbnail"               //    File

/* Chat */
let PF_CHAT_CLASS_NAME                   = "Chat"                    //    Class name
let PF_CHAT_USER                         = "user"                    //    Pointer to User Class
let PF_CHAT_GROUPID                      = "groupId"                 //    String
let PF_CHAT_TEXT                         = "text"                    //    String
let PF_CHAT_PICTURE                      = "profileImage"            //    File
let PF_CHAT_VIDEO                        = "video"                   //    File
let PF_CHAT_CREATEDAT                    = "createdAt"               //    Date

/* Groups */
let PF_GROUPS_CLASS_NAME                = "Groups"                  //    Class name
let PF_GROUPS_NAME                      = "name"                    //    String
let PARTICIPANTS                        = "participants"
let CREATEDBY                           = "createdBy"
let PF_GROUPMESSAGES_CLASS_NAME         = "GroupsMessages"
let GROUPICON                           = "groupIcon"

/* Messages*/
let PF_MESSAGES_CLASS_NAME               = "Messages"                //    Class name
let PF_MESSAGES_USER                     = "user"                    //    Pointer to User Class
let PF_MESSAGES_GROUPID                  = "groupId"                 //    String
let PF_MESSAGES_DESCRIPTION              = "description"             //    String
let PF_MESSAGES_LASTUSER                 = "lastUser"                //    Pointer to User Class
let PF_MESSAGES_LASTMESSAGE              = "lastMessage"             //    String
let PF_MESSAGES_COUNTER                  = "counter"                 //    Number
let PF_MESSAGES_UPDATEDACTION            = "updatedAction"           //    Date

/* Notification */
let NOTIFICATION_APP_STARTED             = "NCAppStarted"
let NOTIFICATION_USER_LOGGED_IN          = "NCUserLoggedIn"
let NOTIFICATION_USER_LOGGED_OUT         = "NCUserLoggedOut"


/*Event Review*/
let REVIEW_CLASS_NAME                    = "comment"
let REVIEW_USER_NAME                     = "username"
let REVIEW_USER_IMAGE                    = "userIamge"
let REVIEW_TEXT                          = "text"
let REVIEW_EVENT_OBJECT_ID               = "eventObjectId"
let REVIEW_TIME_UPDATEDACTION            = "updatedAction"
let REVIEW_COMMENTBY                     = "user"

/*Teams Class*/
let TEAM_CLASS_NAME                = "Teams"                  //    Class name
let TEAM_NAME                      = "name"                    //    String
let TEAM_PARTICIPANTS              = "members"
let TEAM_CREATEDBY                 = "createdBy"

/* */
let GAME_LOCATION                   = "location"
let GAME_LOCATION_NAME              = "locationName"
let GAME_START_TIME                 = "startTime"
let GAME_END_TIME                   = "endTime"
let GAME_PIRCE                      = "price"
let GAME_CREATED_BY                 = "CreatedBy"
let GAME_PLAYER                     = "player"
let GAME_SKILL_LEVEL                = "skillLevel"
let GAME_TEAM_NAME                  = "teamName"
let GAME_TEAM_ICON                  = "teamIcon"
let GAME_TYPE                       = "eventType"

let PARSE_SERVER                    = "wss://teamup.back4app.io"



extension UIImage {
    var circle: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result!
    }
    
    func imageWithSize(_ size:CGSize) -> UIImage {
        var scaledImageRect = CGRect.zero
        
        let aspectWidth:CGFloat = size.width / self.size.width
        let aspectHeight:CGFloat = size.height / self.size.height
        let aspectRatio:CGFloat = min(aspectWidth, aspectHeight)
        scaledImageRect.size.width = self.size.width * aspectRatio
        scaledImageRect.size.height = self.size.height * aspectRatio
        scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
        scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        self.draw(in: scaledImageRect)
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0 / 2)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension UICollectionView {
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = deepPurple
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 16)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
}
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func setCellShadow() {
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 1.0
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 15
    }
    func setUserCellShadow(){
        self.backgroundColor = .white
        self.layer.shadowOpacity = 0.4
        self.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.black.cgColor
    }
    func setAnchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?,
                   bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,
                   paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat,
                   paddingRight: CGFloat, width: CGFloat = 0, height: CGFloat = 0) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }
    
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
    
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }
}


extension UIAlertController{
    func addImage(image: UIImage){
        let maxSize = CGSize(width: 245, height: 300)
        let imgsize = image.size
        var ratio: CGFloat!
        if (imgsize.width > imgsize.height){
            ratio = maxSize.width / imgsize.width
        }else{
            ratio = maxSize.height / imgsize.height
        }
        let scaledSize = CGSize(width: imgsize.width * ratio, height: imgsize.height * ratio)
        var resizedImage = image.imageWithSize(scaledSize)
        if (imgsize.height > imgsize.width){
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets.init(top: 0, left: -left, bottom: 0, right: 0))
        }
        let imgAction = UIAlertAction ( title: " " , style : .default , handler : nil )
        imgAction.isEnabled = false
        imgAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")
        self.addAction(imgAction)
    }
}

extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
}

extension UIButton {
    func leftImage(image: UIImage, renderMode: UIImage.RenderingMode) {
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: image.size.width / 2)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func rightImage(image: UIImage, renderMode: UIImage.RenderingMode){
        self.setImage(image.withRenderingMode(renderMode), for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left:image.size.width / 2, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .right
        self.imageView?.contentMode = .scaleAspectFit
    }
}

extension UILabel {
    func addTextWithImage(text: String, image: UIImage, imageBehindText: Bool, keepPreviousText: Bool) {
        let lAttachment = NSTextAttachment()
        lAttachment.image = image
        
        // 1pt = 1.32px
        let lFontSize = round(self.font.pointSize * 1.32)
        let lRatio = image.size.width / image.size.height
        
        lAttachment.bounds = CGRect(x: 0, y: ((self.font.capHeight - lFontSize) / 2).rounded(), width: lRatio * lFontSize, height: lFontSize)
        
        let lAttachmentString = NSAttributedString(attachment: lAttachment)
        
        if imageBehindText {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(string: text)
            }
            
            lStrLabelText.append(lAttachmentString)
            self.attributedText = lStrLabelText
        } else {
            let lStrLabelText: NSMutableAttributedString
            
            if keepPreviousText, let lCurrentAttributedString = self.attributedText {
                lStrLabelText = NSMutableAttributedString(attributedString: lCurrentAttributedString)
                lStrLabelText.append(NSMutableAttributedString(attributedString: lAttachmentString))
                lStrLabelText.append(NSMutableAttributedString(string: text))
            } else {
                lStrLabelText = NSMutableAttributedString(attributedString: lAttachmentString)
                lStrLabelText.append(NSMutableAttributedString(string: text))
            }
            
            self.attributedText = lStrLabelText
        }
    }
    
    func removeImage() {
        let text = self.text
        self.attributedText = nil
        self.text = text
    }
}

extension Date {
    func compareTo(date: Date, toGranularity: Calendar.Component ) -> ComparisonResult  {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.compare(self, to: date, toGranularity: toGranularity)
    }
}
extension Int {
    func toString() -> String {
        let myString = String(self)
        return myString
    }
}

extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .white
        view.clipsToBounds = true
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        
        if(Direction.Left == direction){ // image left
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            self.rightViewMode = .always
            self.rightView = mainView
        }
    }
}
