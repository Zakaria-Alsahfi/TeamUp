//
//  NewLoginPage.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/20/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NewLoginPage: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setUpView()
        RegisterButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        FacebookButton.addTarget(self, action: #selector(loginWithFacebook), for: .touchUpInside)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = " "
    }
    
    @objc func login(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "register") as! Register
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func GoToMainPage(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToHomePage")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    func locationSetUp(){
        DispatchQueue.main.async {
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationPreference")
            self.present(viewController, animated: true, completion: nil)
        }
    }
    @objc func loginWithFacebook() {
        // Set permissions required from the facebook user account
        let permissionsArray = [""]
        // Login PFUser using Facebook
        PFFacebookUtils.logInInBackground(withReadPermissions: permissionsArray) { (user, error) in
            if user != nil {
                if (user?.isNew)! {
                    print("User signed up and logged in through Facebook!")
                    self.loadData()
                }else {
                    _ = PFUser.current()
                    self.GoToMainPage()
                }
            }else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    func loadData() {
        let currUser = PFUser.current()!
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, first_name, last_name, email, picture.type(large)"])
        
        request!.start(completionHandler: { connection, result, error in
            if error == nil {
                // result is a dictionary with the user's Facebook data
                let userData = result as? [AnyHashable : Any]
                
                let facebookID = userData?["id"] as? String
                let firstName = userData?["first_name"] as? String
                let LastName = userData?["last_name"] as? String
                print(firstName!)
                print(LastName!)
                let email = userData?["email"]as? String
                
                let pictureURL = URL(string: "https://graph.facebook.com/\(facebookID ?? "")/picture?type=large&return_ssl_resources=1")
                var urlRequest: URLRequest? = nil
                if let anURL = pictureURL {
                    urlRequest = URLRequest(url: anURL)
                }
                
                // Run network request asynchronously
                if let aRequest = urlRequest {
                    NSURLConnection.sendAsynchronousRequest(aRequest, queue: OperationQueue.main, completionHandler: { response, data, connectionError in
                        if connectionError == nil && data != nil {
                            // Set the image in the imageView
                            // ...
                            let image = UIImage(data: data!)
                            let imageData = image!.jpegData(compressionQuality: 0.8)
                            let imageFile = PFFile(name:"avatar.bin", data:imageData!)
                            currUser[USER_AVATAR] = imageFile
                        }
                    })
                }
                currUser.username = email
                currUser.email = email
                currUser[USER_FIRST_NAME] = firstName
                currUser[USER_LAST_NAME] = LastName
                currUser.saveInBackground(block: { (succ, error) in
                    if error == nil {
                        self.dismiss(animated: false, completion: nil)
                        self.hideHUD()
                        self.locationSetUp()
                    }})
                
            } else if error?.localizedDescription == "OAuthException" {
                // Since the request failed, we can check if it was due to an invalid session
                print("The facebook session was invalidated")
                PFFacebookUtils.unlinkUser(inBackground: PFUser.current()!)
            } else {
                if let anError = error {
                    print("Some other error: \(anError)")
                }
            }
        })
    }
    
    let logo: UILabel = {
        let label = UILabel()
        label.text = "Team Up"
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 50)
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
        label.shadowColor = deepPurple
        label.shadowOffset = CGSize(width: 2, height: 2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let msg: UILabel = {
        let label = UILabel()
        label.text = "Find game near and enjoy"
        label.textColor = deepPurple
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var RegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = deepPurple
        button.setTitle("Email", for: UIControl.State())
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var FacebookButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Login in with Fasebook", for: UIControl.State())
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    func setUpView(){
        
        view.addSubview(logo)
        view.addSubview(msg)
        view.addSubview(FacebookButton)
        view.addSubview(RegisterButton)
        
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logo.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        msg.topAnchor.constraint(equalTo: logo.bottomAnchor).isActive = true
        msg.centerXAnchor.constraint(equalTo: logo.centerXAnchor).isActive = true
        
        
        FacebookButton.topAnchor.constraint(equalTo: msg.bottomAnchor, constant: 120).isActive = true
        FacebookButton.centerXAnchor.constraint(equalTo: logo.centerXAnchor).isActive = true
        FacebookButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        FacebookButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        
        RegisterButton.topAnchor.constraint(equalTo: FacebookButton.bottomAnchor, constant: 10).isActive = true
        RegisterButton.centerXAnchor.constraint(equalTo: logo.centerXAnchor).isActive = true
        RegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        RegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        RegisterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        
    }
}
