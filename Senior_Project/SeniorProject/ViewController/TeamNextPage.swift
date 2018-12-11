//
//  TeamNextPage.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/23/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI

private let reuseIdentifier = "Cell"
private let playerListId = "playerListId"

class TeamNextPage: UIViewController {

    
    var address = ""
    var latitude = 0.0
    var longitude = 0.0
    var locality = ""
    var locationName = ""
    var price = ""
    var startTime = ""
    var endTime = ""
    var skilllevel = ""
    var groupImage: UIImageView!
    var groupName = ""
    
    var rightBarButton: UIBarButtonItem!
    var users: PFUser!
    var teamMembers = [PFUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = deepPurple
        self.navigationItem.title = "New Team"
        self.rightBarButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.rightBarButtonItem = self.rightBarButton
        self.rightBarButton.tintColor = .white
        
        addView()
        teamNametf.delegate = self
        print(teamMembers.count)
        headLabel.text = "\tPARTICIPANTS: \(teamMembers.count)"
        print("\(address)\n\(price)\n\(skilllevel)\n\(startTime)\n\(endTime)")
        
        var tapGesture = UITapGestureRecognizer()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(groupAvatarButt(_:)))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    let CollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = viewBackgroundColore
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logo-camera")
        iv.backgroundColor = .white
        iv.layer.cornerRadius = 40
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Please provide a team name\nand optional team icon"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = deepPurple
        label.numberOfLines = 2
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let teamNametf: UITextField = {
        let text = UITextField()
        text.attributedPlaceholder = NSAttributedString(string: "Team Name", attributes: [NSAttributedString.Key.foregroundColor: deepPurple])
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .done
        text.autocorrectionType = .default
        text.autocapitalizationType = .words
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = deepPurple
        label.textAlignment = .right
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let headLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = deepPurple
        label.backgroundColor = .white
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let bottomSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func addView(){
        print(view.frame)
        view.backgroundColor = .clear
        CollectionView.dataSource = self
        CollectionView.delegate = self
        CollectionView.register(MemmberCell.self, forCellWithReuseIdentifier: playerListId)
        
        view.addSubview(imageView)
        view.addSubview(noteLabel)
        view.addSubview(teamNametf)
        view.addSubview(countLabel)
        view.addSubview(topSeparatorView)
        view.addSubview(bottomSeparatorView)
        view.addSubview(headLabel)
        view.addSubview(CollectionView)
        
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        topSeparatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        topSeparatorView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 30).isActive = true
        topSeparatorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        teamNametf.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 30).isActive = true
        teamNametf.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 1).isActive = true
        teamNametf.widthAnchor.constraint(equalToConstant: 240).isActive = true
        teamNametf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        countLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        countLabel.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor, constant: 1).isActive = true
        countLabel.leftAnchor.constraint(equalTo: teamNametf.rightAnchor).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomSeparatorView.topAnchor.constraint(equalTo: teamNametf.bottomAnchor, constant: 1).isActive = true
        bottomSeparatorView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 30).isActive = true
        bottomSeparatorView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        noteLabel.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 2).isActive = true
        noteLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 30).isActive = true
        noteLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        headLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 30).isActive = true
        headLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        CollectionView.topAnchor.constraint(equalTo: headLabel.bottomAnchor, constant: 20).isActive = true
        CollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        CollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    @objc func goBack(){
        
        let privateGame = PFObject (className: EVENT_CLASS_NAME)
        privateGame[GAME_LOCATION] = address
        privateGame[GAME_START_TIME] = startTime.replacingOccurrences(of: "\n", with: ", ")
        privateGame[GAME_END_TIME] = endTime.replacingOccurrences(of: "\n", with: ", ")
        privateGame[GAME_PIRCE] = "$\(price)"
        privateGame["user"] = PFUser.current()?.username
        privateGame.setObject(PFUser.current()!, forKey: GAME_CREATED_BY)
        privateGame.addObjects(from: [PFUser.current()!], forKey: "going")
        for i in self.teamMembers {
            let teamMember = i as PFUser
            privateGame.addObjects(from: [teamMember], forKey: GAME_PLAYER)
        }
        privateGame[GAME_SKILL_LEVEL] = skilllevel
        privateGame[GAME_TEAM_NAME] = teamNametf.text
        privateGame[COUNTS] = teamMembers.count + 1
        privateGame[JOINED] = teamMembers.count + 1
        privateGame["locationName"] = locationName
        privateGame["city"] = locality
        let myGeoPoint = PFGeoPoint(latitude: latitude, longitude: longitude)
        privateGame["coordinate"] = myGeoPoint
        if imageView.image != nil {
            let imageData = imageView.image!.jpegData(compressionQuality: 0.5)
            let imageFile = PFFile(name:"avatar.jpg", data:imageData!)
            privateGame[GAME_TEAM_ICON] = imageFile
        }
        privateGame[GAME_TYPE] = "Private"
        privateGame.saveInBackground{ (success: Bool , error: Error?) -> Void in
            if (success) {
                print("success")
                print(privateGame.objectId!)
                let object = PFObject(className: TEAM_CLASS_NAME)
                object.setObject(PFUser.current()!, forKey: TEAM_CREATEDBY)
                for i in self.teamMembers {
                    let teamMember = i as PFUser
                    object.addObjects(from: [teamMember], forKey: TEAM_PARTICIPANTS)
                }
                
                object[GAME_TEAM_NAME] = self.teamNametf.text
                if self.imageView.image != nil {
                    let imageData = self.imageView.image!.jpegData(compressionQuality: 0.5)
                    let imageFile = PFFile(name:"avatar.jpg", data:imageData!)
                    object[GAME_TEAM_ICON] = imageFile
                }
                object.saveInBackground(block: { (success: Bool , error: Error?) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                    }
                })
                DispatchQueue.main.async {
                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToHomePage")
                    self.present(viewController, animated: true, completion: nil)
                    
                }
                
            }else{
                print(error as Any)
                
            }
            
        }
    }
    
    
    
    
}


class MemmberCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageView: PFImageView = {
        let iv = PFImageView()
        iv.layer.cornerRadius = 30
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = deepPurple
        label.numberOfLines = 1
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 1).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
    }
    
}

extension TeamNextPage: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return teamMembers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playerListId, for: indexPath) as! MemmberCell
        let user = teamMembers[indexPath.row]
        
        cell.imageView.file = user[USER_AVATAR] as? PFFile
        cell.imageView.loadInBackground()
        
        cell.nameLabel.text = user[USER_USERNAME] as? String
        return cell
    }
}

extension TeamNextPage: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        let newLength = textField.text!.utf16.count + string.utf16.count - range.length
        print("\(textField.text!.utf16.count)")
        print("\(string.utf16.count)")
        print("\(range.length)")
        //change the value of the label
        countLabel.text =  String(newLength)
        return updatedText.count <= 24
    }
}

extension TeamNextPage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func groupAvatarButt(_ sender: AnyObject){
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
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}
