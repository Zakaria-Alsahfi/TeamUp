//
//  Register.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/21/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class Register: UIViewController, UIGestureRecognizerDelegate {
    
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var tapView: UITapGestureRecognizer = UITapGestureRecognizer()
    var loginTap: UITapGestureRecognizer = UITapGestureRecognizer()
    
    var leftBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = deepPurple
        self.navigationController?.navigationBar.tintColor = .white
        let image = UIImage(named: "back")
        self.leftBarButton = UIBarButtonItem(image: image?.imageWithSize(CGSize(width: 40, height: 40)), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = self.leftBarButton

        setUpView()
        
        
        tap.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(changeAvatarButt(_:)))
        userImage.addGestureRecognizer(tap)
        userImage.isUserInteractionEnabled = true
        
        tapView.delegate = self
        tapView = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapView)
        view.isUserInteractionEnabled = true
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        RegisterButton.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        loginTap.delegate = self
        loginTap = UITapGestureRecognizer(target: self, action: #selector(login))
        loginStackView.addGestureRecognizer(loginTap)
        loginStackView.isUserInteractionEnabled = true
        
        
    }
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = firstNameTextField.text, let lastName = lastNameTextField.text else {
            print("Form is not valid")
            return
        }
        if name.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty {
            self.warningAlert("All Fields Are Required")
        }else {
            let finalEmail = email.trimmingCharacters(in: NSCharacterSet.whitespaces)
            let newUser = PFUser()
            newUser.username = finalEmail
            newUser[USER_FIRST_NAME] = name
            newUser[USER_LAST_NAME] = lastName
            newUser[USER_FULLNAME] = name + lastName
            newUser.password = password
            newUser.email = finalEmail
            let defaultImgage = userImage.image
            let imageData = defaultImgage!.jpegData(compressionQuality: 0.5)
            let imageFile = PFFile(name:"user_avatra", data:imageData!)
            
            newUser[USER_AVATAR] = imageFile
            // Sign up the user asynchronously
            newUser.signUpInBackground(block: { (succeed, error) -> Void in
                
                if ((error) != nil) {
                    self.warningAlert((error?.localizedDescription)!)
                    
                } else {
                    self.locationSetUp()
                }
            })
        }
    }
    
    func locationSetUp(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationPreference")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    let imageButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        let image = UIImage(named: "logo-camera")
        button.setImage(image?.imageWithSize(CGSize(width: 50, height: 50)), for: .normal)
        button.layer.cornerRadius = 30
        button.backgroundColor = viewBackgroundColore
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let userImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo-camera")
        image.clipsToBounds = true
        image.layer.cornerRadius = 30
        image.backgroundColor = viewBackgroundColore
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let textlabel: UILabel = {
        let label = UILabel()
        label.text = "Upload your photo"
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First Name"
        tf.setLeftPaddingPoints(15)
        tf.returnKeyType = .next
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let firstNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last Name"
        tf.setLeftPaddingPoints(15)
        tf.returnKeyType = .next
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let lastNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.setLeftPaddingPoints(15)
        tf.returnKeyType = .next
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.setLeftPaddingPoints(15)
        tf.isSecureTextEntry = true
        tf.returnKeyType = .done
        tf.clipsToBounds = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let RegisterButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        let image = UIImage(named: "checkmark")
        button.setImage(image?.imageWithSize(CGSize(width: 50, height: 50)), for: .normal)
        button.layer.cornerRadius = 30
        button.backgroundColor = viewBackgroundColore
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let loginStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.backgroundColor = .white
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.equalSpacing
        sv.spacing = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let loginLabel: UILabel = {
        let label = UILabel()
        label.text = "Have an account?"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: UIControl.State())
        button.setTitleColor(deepPurple, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

























extension Register {
    
    func setUpView(){

        view.addSubview(userImage)
        view.addSubview(textlabel)
        view.addSubview(firstNameTextField)
        view.addSubview(firstNameSeparatorView)
        view.addSubview(lastNameTextField)
        view.addSubview(lastNameSeparatorView)
        view.addSubview(emailTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSeparatorView)
        view.addSubview(RegisterButton)
        
        view.addSubview(loginStackView)
        view.addSubview(loginLabel)
        view.addSubview(loginButton)
    
        
        userImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 60).isActive = true
        userImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        textlabel.centerYAnchor.constraint(equalTo: userImage.centerYAnchor).isActive = true
        textlabel.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 20).isActive = true
        
        textlabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        textlabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        firstNameTextField.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        firstNameSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        firstNameSeparatorView.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor).isActive = true
        firstNameSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        firstNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        lastNameTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 10).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        lastNameSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lastNameSeparatorView.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor).isActive = true
        lastNameSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        lastNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        passwordSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        RegisterButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 60).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        RegisterButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        loginStackView.addArrangedSubview(loginLabel)
        loginStackView.addArrangedSubview(loginButton)
        loginStackView.topAnchor.constraint(equalTo: RegisterButton.bottomAnchor, constant: 20).isActive = true
        loginStackView.centerXAnchor.constraint(equalTo: RegisterButton.centerXAnchor).isActive = true

    }
    
    @objc func login(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! Login
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        let image = UIImage(named: "back1")
        backButton.setImage(image?.imageWithSize(CGSize(width: 50, height: 30)), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: -20, bottom: -2, right: 0)
        backButton.setTitle("", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func goBack(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewLoginPage") as! NewLoginPage
            let transition = CATransition()
            transition.duration = 0.0
            transition.type = .moveIn
            transition.subtype = .fromLeft
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    
    func addObservers(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -100, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }

}
extension Register: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            userImage.image = image
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

extension Register: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
            break
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
            break
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }
}
