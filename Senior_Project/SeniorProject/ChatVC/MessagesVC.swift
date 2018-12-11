//
//  MessagesVC.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 8/8/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: UITableViewController, UIActionSheetDelegate, SelectSingleDelegate {
    
    var messages = [PFObject]()
    
    @IBOutlet var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(singleUser))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(cleanup), name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_OUT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadMessages), name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(loadMessages), for: UIControl.Event.valueChanged)
        self.tableView?.addSubview(self.refreshControl!)
        self.emptyView?.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTabCounter()
        self.loadMessages()
    }

    // MARK: - Backend methods
    
    @objc func loadMessages() {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()!)
        query.includeKey(PF_MESSAGES_LASTUSER)
        query.order(byDescending: PF_MESSAGES_UPDATEDACTION)
        query.findObjectsInBackground{ (objects, error) -> Void in
            if error == nil {
                self.messages.removeAll(keepingCapacity: false)
                self.messages += objects!
                self.tableView.reloadData()
                self.updateEmptyView()
                self.updateTabCounter()
            } else {
                self.showHUD("Network error")
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    // MARK: - Helper methods
    
    func updateEmptyView() {
        self.emptyView?.isHidden = self.messages.count != 0
    }
    
    func updateTabCounter() {
        var total = 0
        for message in self.messages {
            total += (message[PF_MESSAGES_COUNTER]! as AnyObject).integerValue
        }
        let item = self.tabBarController!.tabBar.items![3]
        item.badgeValue = (total == 0) ? nil : "\(total)"
    }

    // MARK: - User actions
    
    func openChat(groupId: String) {
        self.performSegue(withIdentifier: "messagesChatSegue", sender: groupId)
    }

    @objc func cleanup() {
        self.messages.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
        self.updateTabCounter()
        self.updateEmptyView()
    }
    @objc func singleUser(){
        self.performSegue(withIdentifier: "selectSingleSegue", sender: self)
    }
    
    func didSelectSingleUser(user user2: PFUser) {
        let user1 = PFUser.current()!
        let groupId = Messages.startPrivateChat(user1: user1, user2: user2)
        self.openChat(groupId: groupId)
    }
    // MARK: - Prepare for segue to chatVC
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }else if segue.identifier == "selectSingleSegue" {
            let selectSingleVC = (segue.destination as! UINavigationController).topViewController as! SelectSingleUser
                selectSingleVC.delegate = self
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell") as! MessagesCell
        cell.bindData(message: self.messages[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            Messages.deleteMessageItem(message: self.messages[indexPath.row])
            self.messages.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            self.updateEmptyView()
            self.updateTabCounter()
        }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let message = self.messages[indexPath.row] as PFObject
            self.openChat(groupId: message[PF_MESSAGES_GROUPID] as! String)
        
    }
}
