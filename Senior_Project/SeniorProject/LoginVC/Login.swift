//
//  Login.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Login: UIViewController, UIGestureRecognizerDelegate{
    
    var tap: UITapGestureRecognizer = UITapGestureRecognizer()
    var forgotPasswordTap: UITapGestureRecognizer = UITapGestureRecognizer()
    var singUpTap: UITapGestureRecognizer = UITapGestureRecognizer()
    var leftBarButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = deepPurple
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let image = UIImage(named: "back")
        self.leftBarButton = UIBarButtonItem(image: image?.imageWithSize(CGSize(width: 40, height: 40)), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = self.leftBarButton
        
        tap.delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true

        setUpView()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        singUpTap.delegate = self
        singUpTap = UITapGestureRecognizer(target: self, action: #selector(register))
        singUpStackView.addGestureRecognizer(singUpTap)
        singUpStackView.isUserInteractionEnabled = true
        
        forgotPasswordTap.delegate = self
        forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(handleForgotPassword))
        forgetPasswordStackView.addGestureRecognizer(forgotPasswordTap)
        forgetPasswordStackView.isUserInteractionEnabled = true
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    @objc func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        if email.isEmpty || password.isEmpty {
            self.warningAlert("Email And Password Are Required")
        }else {
            // Send a request to login
            PFUser.logInWithUsername(inBackground: email, password: password, block: { (user, error) -> Void in
                
                if PFUser.current() != nil {
                    self.GoToMainPage()
                    
                } else {
                    self.warningAlert((error?.localizedDescription)!)
                }
            })
        }
    }
    
    @objc func register(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "register") as! Register
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func handleForgotPassword(){
        let titlePrompt = UIAlertController(title: "Reset password",
                                            message: "Enter the email you registered with:",
                                            preferredStyle: .alert)
        
        var titleTextField: UITextField?
        titlePrompt.addTextField { (textField) -> Void in
            titleTextField = textField
            textField.placeholder = "Email"
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        titlePrompt.addAction(cancelAction)
        
        titlePrompt.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { (action) -> Void in
            if let textField = titleTextField {
                self.resetPassword(email: textField.text!)
            }
        }))
        
        self.present(titlePrompt, animated: true, completion: nil)
    }
    
    func resetPassword(email : String){
    
    // convert the email string to lower case
    let email = email
    // remove any whitespaces before and after the email address
    let emailClean = email.trimmingCharacters(in: NSCharacterSet.whitespaces)
        
    PFUser.requestPasswordResetForEmail(inBackground: emailClean) { (success, error) -> Void in
        if (error == nil) {
            let success = UIAlertController(title: "Success", message: "Success! Check your email!", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            success.addAction(okButton)
            self.present(success, animated: false, completion: nil)
            
        }else {
            let errormessage = error!._userInfo!["error"] as! NSString
            let error = UIAlertController(title: "Cannot complete request", message: errormessage as String, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            error.addAction(okButton)
            self.present(error, animated: false, completion: nil)
        }
    }
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
    
    func GoToMainPage(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToHomePage")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = .emailAddress
        tf.returnKeyType = .next
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
        tf.isSecureTextEntry = true
        tf.keyboardType = .default
        tf.returnKeyType = .go
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "checkmark")
        button.setImage(image?.imageWithSize(CGSize(width: 50, height: 50)), for: .normal)
        button.layer.cornerRadius = 30
        button.backgroundColor = viewBackgroundColore
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgetPasswordStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.backgroundColor = .white
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.equalSpacing
        sv.spacing = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let forgetPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Forgot Your Password?"
        label.textColor = .lightGray
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset it", for: UIControl.State())
        button.setTitleColor(deepPurple, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let singUpStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.backgroundColor = .white
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.equalSpacing
        sv.spacing = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let singUpLable: UILabel = {
        let label = UILabel()
        label.text = "No account?"
        label.textColor = .lightGray
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let singUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: UIControl.State())
        button.setTitleColor(deepPurple, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}



















extension Login: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return true
    }

}




extension Login{
    
    func setUpView(){
        
        view.addSubview(emailTextField)
        view.addSubview(emailSeparatorView)
        view.addSubview(passwordTextField)
        view.addSubview(passwordSeparatorView)
        view.addSubview(loginButton)
        
        view.addSubview(forgetPasswordStackView)
        view.addSubview(forgotPasswordButton)
        view.addSubview(forgetPasswordLabel)
        
        view.addSubview(singUpStackView)
        view.addSubview(singUpLable)
        view.addSubview(singUpButton)
        
        
        emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 18).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        
        passwordSeparatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        passwordSeparatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        forgetPasswordStackView.addArrangedSubview(forgetPasswordLabel)
        forgetPasswordStackView.addArrangedSubview(forgotPasswordButton)
        forgetPasswordStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        forgetPasswordStackView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        
        singUpStackView.addArrangedSubview(singUpLable)
        singUpStackView.addArrangedSubview(singUpButton)
        singUpStackView.topAnchor.constraint(equalTo: forgetPasswordLabel.bottomAnchor, constant: 5).isActive = true
        singUpStackView.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
    }

}
