//
//  GameChatTest.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/5/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class GameChatTest: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var CellId = "CellId"
    var refreshControl:UIRefreshControl!
    var commentsObject = [PFObject]()
    var objectId = ""
    var gameCreatedBy = ""
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(reply(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let inputTextField: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 16)
        text.autocorrectionType = .default
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var bottomConstraint: NSLayoutConstraint?
    var textHeightConstraint: NSLayoutConstraint?
    var containerHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CellId)
        collectionView?.backgroundColor = .clear
        refreshControl = UIRefreshControl()
        refreshControl.tintColor = deepPurple
        collectionView?.addSubview(refreshControl)
        
        setupInputComponents()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        loadComment()
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        inputTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadComment()
    }
    
    @objc func loadData(){
        collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentsObject.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellId, for: indexPath) as! CommentCell
        self.configureCell(cell, atIndexPath: indexPath)
        return cell
        
    }
    
    func configureCell(_ cell: AnyObject, atIndexPath indexPath: IndexPath) {
        let ccell: CommentCell = (cell as! CommentCell)
        let object = commentsObject[indexPath.row]
        if let commentUser = object[REVIEW_COMMENTBY] as? PFUser {
            let profilePicture = commentUser[USER_AVATAR] as? PFFile
            if profilePicture != nil {
                profilePicture?.getDataInBackground(block: { (imageData, error) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            ccell.profileImage.image = UIImage(data: imageData)
                            
                        }}})
                
            }
        }
        ccell.messageText.text = object.object(forKey: REVIEW_TEXT) as? String
        ccell.messageTime.text = self.formatDate(Date())
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "E, MMM dd h:mma"
        let formattedDate: String = dateFormatter.string(from: date)
        return formattedDate
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = commentsObject[indexPath.row].object(forKey: REVIEW_TEXT) as? String
        if let messageText = text?.description {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 48, right: 0)
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = ((userInfo[UIResponder.keyboardFrameBeginUserInfoKey]) as AnyObject).cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            let height = (keyboardFrame?.height)!
            bottomConstraint?.constant = isKeyboardShowing ? -height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.view.layoutIfNeeded()
                self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 50, right: 0)
            }, completion: { (completed) in
                
                if isKeyboardShowing {
                    let indexPath = IndexPath(item: self.commentsObject.count - 1 , section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    @objc func loadComment(){
        let query = PFQuery(className: REVIEW_CLASS_NAME)
        query.whereKey(REVIEW_EVENT_OBJECT_ID, equalTo: objectId)
        query.includeKey(REVIEW_COMMENTBY)
        query.order(byDescending: "createdAt" )
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                self.commentsObject.removeAll(keepingCapacity: false)
                self.commentsObject += objects!
                print(self.commentsObject.count)
                self.collectionView.reloadData()
            }else {
                self.showHUD("Network error")
            }
        }
        
    }
    
    @objc func reply(_: UIButton) {
        let date = NSDate()
        let seconds = date.timeIntervalSinceNow
        let elapsed = Utilities.timeElapsed(seconds: seconds)
        let review = PFObject(className: REVIEW_CLASS_NAME)
        review.setObject(PFUser.current()!, forKey: REVIEW_COMMENTBY)
        review[REVIEW_USER_NAME] = PFUser.current()?.username
        review[REVIEW_TEXT] = inputTextField.text
        review[REVIEW_EVENT_OBJECT_ID] = objectId
        review[REVIEW_TIME_UPDATEDACTION] = elapsed
        review["gameCreatedBy"] = self.gameCreatedBy
        review.saveInBackground()
        self.inputTextField.resignFirstResponder()
        self.inputTextField.text = ""
        loadComment()
        loadData()
        adjustTextViewHeight()
    }
    
    
    
    func setupInputComponents() {
        self.adjustTextViewHeight()
        view.addSubview(messageInputContainerView)
        messageInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        messageInputContainerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        containerHeightConstraint = messageInputContainerView.heightAnchor.constraint(equalToConstant: 48)
        containerHeightConstraint?.isActive = true
        
        
        messageInputContainerView.addSubview(separatorLineView)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(inputTextField)
        
        separatorLineView.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: messageInputContainerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        sendButton.rightAnchor.constraint(equalTo: messageInputContainerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: messageInputContainerView.heightAnchor).isActive = true
        
        
        self.inputTextField.leftAnchor.constraint(equalTo: messageInputContainerView.leftAnchor, constant: 8).isActive = true
        self.inputTextField.topAnchor.constraint(equalTo: separatorLineView.bottomAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.textHeightConstraint = inputTextField.heightAnchor.constraint(equalToConstant: 47)
        self.textHeightConstraint?.isActive = true
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = self.inputTextField.frame.size.width
        
        let newSize = self.inputTextField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let difference = newSize.height - 35 //new line
        self.textHeightConstraint?.constant = newSize.height
        self.containerHeightConstraint?.constant = 48 + difference //new line
        self.view.layoutIfNeeded()
    }
    
}

extension GameChatTest: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
    }
    
}
