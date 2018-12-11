//
//  HomeController.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 5/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse

class HomeController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var rightBarButton: UIBarButtonItem!
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var total = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = deepPurple
        self.rightBarButton = UIBarButtonItem(image: UIImage(named: "settings-1"), style: .plain, target: self, action: #selector(sittingView))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.rightBarButton.tintColor = .white
        
        tap.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(changeAvatarButt(_:)))
        avatar.addGestureRecognizer(tap)
        avatar.isUserInteractionEnabled = true
        self.addSubviews()
        self.numberOfHostedGame()
        self.numberOfAttendedGame()
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationItem.title = " "
        self.navigationItem.backBarButtonItem?.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.getUserData()
    }
    
    func getUserData(){
        let currentUser = PFUser.current()
        currentUser?.fetchInBackground(block: { (User, error) in
            if let user = User as? PFUser {
                let firstName = user.object(forKey: USER_FIRST_NAME) as? String
                let lastName = user.object(forKey: USER_LAST_NAME) as? String
                self.navigationItem.title = "\(firstName!) \(lastName!)"
                let imageFile = user.value(forKey: USER_AVATAR) as? PFFile
                if imageFile != nil {
                    imageFile?.getDataInBackground(block: { (imageData, error) -> Void in
                        if error == nil {
                            if let imageData = imageData {
                                self.avatar.image = self.avatar.image?.circle
                                self.avatar.image = UIImage(data:imageData)
                            }}})
                }
            }
        })
    }
    
    func numberOfHostedGame(){
        let query = PFQuery(className: EVENT_CLASS_NAME)
        var hostedGame = [PFObject]()
        query.whereKey("user", equalTo: PFUser.current()!.username!)
        query.includeKey(REVIEW_COMMENTBY)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                hostedGame.removeAll(keepingCapacity: false)
                hostedGame += objects!
                self.total = hostedGame.count
                if self.total > 0 {
                    self.hosteLabel.text = "\(self.total) Games orgnaized"
                }else {
                    self.hosteLabel.text = "\(self.total) Game orgnaized"
                }
                print(self.total)
            }else {
                self.showHUD("Network error")
            }
        }
        
    }
    
    func numberOfAttendedGame(){
        let query = PFQuery(className: EVENT_CLASS_NAME)
        var attendedGame = [PFObject]()
        query.whereKey("player", containedIn: [PFUser.current()!])
        query.includeKey(REVIEW_COMMENTBY)
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                attendedGame.removeAll(keepingCapacity: false)
                attendedGame += objects!
                self.total = attendedGame.count
                if self.total > 0 {
                    self.attendedLabel.text = "\(self.total) Games attended"
                }else {
                    self.attendedLabel.text = "\(self.total) Game attended"
                }
                print(self.total)
            }else {
                self.showHUD("Network error")
            }
        }
        
    }
    
    @objc func sittingView(){
        DispatchQueue.main.async {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Settingtable") as! Settingtable
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    let upperView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let aboutText: UILabel = {
        let text = UILabel()
        text.text = "Add information about yourself"
        text.layer.borderWidth = 0
        text.layer.borderColor = UIColor.clear.cgColor
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    let attendedLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0 Games attended"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let hosteLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "0 Games orgnaized"
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func addSubviews() {
        
        view.addSubview(upperView)
        upperView.setUserCellShadow()
        upperView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 5).isActive = true
        upperView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        upperView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        upperView.addSubview(avatar)
        upperView.addSubview(hosteLabel)
        upperView.addSubview(attendedLabel)
        upperView.addSubview(aboutText)

        avatar.leftAnchor.constraint(equalTo: upperView.leftAnchor, constant: 10).isActive = true
        avatar.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 30).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 100).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        attendedLabel.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 30).isActive = true
        attendedLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 50).isActive = true
        attendedLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        hosteLabel.topAnchor.constraint(equalTo: attendedLabel.topAnchor, constant: 30).isActive = true
        hosteLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 50).isActive = true
        hosteLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true

        aboutText.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 10).isActive = true
        aboutText.leftAnchor.constraint(equalTo: upperView.leftAnchor, constant: 10).isActive = true
        aboutText.widthAnchor.constraint(equalTo: upperView.widthAnchor).isActive = true
        aboutText.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: -5).isActive = true
    }

    @objc func changeAvatarButt(_ sender: AnyObject) {
        let alert = UIAlertController(title: APP_NAME,
                                      message: "Select source",
                                      preferredStyle: .alert)
        
        let camera = UIAlertAction(title: "Take a picture", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        let library = UIAlertAction(title: "Choose an Image", style: .default, handler: { (action) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in })
        
        alert.addAction(camera)
        alert.addAction(library)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            avatar.image = image
            let newUser = PFUser.current()
            let defaultImgage = image
            let imageData = defaultImgage.jpegData(compressionQuality: 0.5)
            let imageFile = PFFile(name:"user_avatra", data:imageData!)
            newUser![USER_AVATAR] = imageFile
            newUser?.saveInBackground()
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
