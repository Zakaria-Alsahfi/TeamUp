//
//  UserPage.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Foundation
import UIKit
import Parse

class UserPage: UIViewController {
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
        case thirdChildTab = 2
    }
    
    
    lazy var SegmentedControl: UISegmentedControl = {
        
        let sc = UISegmentedControl(items: ["GOING", "HOSTING", "INVITED"])
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
    
    lazy var GoingGames: UIViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "GoingGames")
        return vc
    }()
    
    lazy var HostingGames : UIViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HostingGames")
        return vc
    }()
    
    lazy var InvitedGame : UIViewController? = {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvitedGame")
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
            vc = GoingGames
        case TabIndex.secondChildTab.rawValue :
            vc = HostingGames
        case TabIndex.thirdChildTab.rawValue:
            vc = InvitedGame
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
    
    @IBAction func newEvent(_ sender: Any) {
        DispatchQueue.main.async {
            let vc: UINavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "newEvent") as! UINavigationController
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.barTintColor = deepPurple
        self.navigationController?.navigationBar.tintColor = .white
        view.addSubview(SegmentedControl)
        view.addSubview(contentView)
        setupConstraints()
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "My Games"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = " "
    }
}
