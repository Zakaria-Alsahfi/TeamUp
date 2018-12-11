//
//  EditProfile.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Foundation
import UIKit
import Parse

class EditProfile: UIViewController {
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.text = "First Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .white
        text.layer.borderColor = UIColor.clear.cgColor
        text.layer.borderWidth = 1
        text.clipsToBounds = true
        text.placeholder = "First Name"
        text.font = UIFont.systemFont(ofSize: 14)
        text.returnKeyType = .next
        text.setLeftPaddingPoints(10)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.text = "Last Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastNameTextField: UITextField = {
        let text = UITextField()
        text.backgroundColor = .white
        text.layer.borderColor = UIColor.clear.cgColor
        text.layer.borderWidth = 1
        text.clipsToBounds = true
        text.placeholder = "Last Name"
        text.font = UIFont.systemFont(ofSize: 14)
        text.returnKeyType = .next
        text.setLeftPaddingPoints(10)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let aboutLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.text = "About"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let aboutTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "Enter Text"
        textView.layer.masksToBounds = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = deepPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        setUpView()
        getUserInfo()
        saveButton.addTarget(self, action: #selector(saveProfileButt(_:)), for: .touchUpInside)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField
        { firstNameTextField.becomeFirstResponder() }
        if textField == lastNameTextField
        { lastNameTextField.becomeFirstResponder() }
        return true
    }
    
    func getUserInfo(){
        let CurrentUser = PFUser.current()
        
        CurrentUser!.fetchInBackground(block: { (User, error) in
            if let user = User as? PFUser {
                self.firstNameTextField.text = user.object(forKey: USER_FIRST_NAME) as? String
                self.lastNameTextField.text = user.object(forKey: USER_LAST_NAME) as? String
            }
        })
    }
    
    @objc func saveProfileButt(_ sender: Any) {
        
        showHUD("Saving...")
        
        let userToUpdate = PFUser.current()!
        userToUpdate[USER_FIRST_NAME] = firstNameTextField.text!
        userToUpdate[USER_LAST_NAME] = lastNameTextField.text!
        userToUpdate["about"] = aboutTextView.text!
        
        userToUpdate.saveInBackground { (success, error) -> Void in
            if error == nil {
                self.hideHUD()
                _ = self.navigationController?.popViewController(animated: true)
            } else {
                self.simpleAlert("\(error!.localizedDescription)")
                self.hideHUD()
            }}
    }
    func setUpView(){
        view.backgroundColor = .white
        
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(aboutLabel)
        view.addSubview(aboutTextView)
        view.addSubview(saveButton)
        
        firstNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant:10).isActive = true
        firstNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant:10).isActive = true
        lastNameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        aboutLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor).isActive = true
        aboutLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant:10).isActive = true
        aboutLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        aboutLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        aboutTextView.topAnchor.constraint(equalTo: aboutLabel.bottomAnchor).isActive = true
        aboutTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant:10).isActive = true
        aboutTextView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        aboutTextView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: aboutTextView.bottomAnchor, constant: 10).isActive = true
        saveButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

