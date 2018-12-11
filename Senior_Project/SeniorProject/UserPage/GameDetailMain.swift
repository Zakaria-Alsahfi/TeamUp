//
//  GameDetailMain.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/1/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class GameDetailMain: UIViewController {
    
    var EventObject = PFObject(className: EVENT_CLASS_NAME)
    var rightBarButton: UIBarButtonItem!
    var objectId = ""
    var gameCreatedBy = ""
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
        case thirdChildTab = 2
    }
    
    lazy var SegmentedControl: UISegmentedControl = {
        
        let sc = UISegmentedControl(items: ["DETAIL", "CHAT","MEMBERS"])
        sc.autoSetDimension(.height, toSize: 30)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.layer.borderWidth = 1
        sc.layer.borderColor = UIColor.gray.cgColor
        sc.layer.cornerRadius = 0
        sc.tintColor = .white
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: UIControl.State.normal)
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: deepPurple], for: UIControl.State.selected)
        sc.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        sc.addTarget(self, action: #selector(switchTabs(_:)), for: .valueChanged)
        return sc
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var currentViewController: UIViewController?
    
    lazy var GameDetail: UIViewController? = {
        let GameVC = self.storyboard?.instantiateViewController(withIdentifier: "GamesDetail") as! GamesDetail
        GameVC.objectId = objectId
        return GameVC
    }()
    
    @objc lazy var GameChat : UIViewController? = {
        let ChatVC = self.storyboard?.instantiateViewController(withIdentifier: "GameChatTest") as! GameChatTest
        ChatVC.objectId = objectId
        ChatVC.gameCreatedBy = gameCreatedBy
        return ChatVC
    }()
    
    lazy var Member : UIViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GameMember") as! GameMember
        vc.objectId = objectId
        return vc
    }()
    
    @objc func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = GameDetail
        case TabIndex.secondChildTab.rawValue :
            vc = GameChat
        case TabIndex.thirdChildTab.rawValue:
            vc = Member
        default:
            return nil
        }
        
        return vc
    }
    
    func setupConstraints(){
        SegmentedControl.autoPinEdge(toSuperviewEdge: .left)
        SegmentedControl.autoPinEdge(toSuperviewEdge: .right)
        SegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        contentView.autoPinEdge(toSuperviewEdge: .left)
        contentView.autoPinEdge(toSuperviewEdge: .right)
        contentView.autoPinEdge(toSuperviewEdge: .bottom)
        contentView.autoPinEdge(.top, to: .bottom, of: SegmentedControl, withOffset: 1)
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(named: "icons8-share")
        self.rightBarButton = UIBarButtonItem(image: image?.imageWithSize(CGSize(width: 50, height: 30)), style: .plain, target: self, action: #selector(shearGame))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.rightBarButton.tintColor = .white
        
        view.addSubview(SegmentedControl)
        view.addSubview(contentView)
        setupConstraints()
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        print(objectId)
        print(gameCreatedBy)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Game Info"
        self.navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    @objc func shearGame() {
        let messageStr  = "Hi there, let's chat on \(APP_NAME) | download it from the iTunes App Store: \(APPSTORE_LINK)"
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
}
