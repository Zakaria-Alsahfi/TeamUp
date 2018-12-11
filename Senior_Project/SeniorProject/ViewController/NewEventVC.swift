//
//  NewEventVC.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/13/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import GoogleMaps

class NewEventVC: UIViewController, GMSMapViewDelegate, UITextFieldDelegate, UIToolbarDelegate {
    
    // Declare variables to hold address form values.
    var street_number: String = ""
    var route: String = ""
    var neighborhood: String = ""
    var locality: String = ""
    var administrative_area_level_1: String = ""
    var country: String = ""
    var postal_code: String = ""
    var postal_code_suffix: String = ""
    var latitude: Double?
    var longitude: Double?
    var locationName: String?
    var skilllevel: String = "All Skill Levels"
    
    
    let datePicker  = UIDatePicker()
    let timePicker = UIDatePicker()
    
    lazy var scrollView: UIScrollView = {
        let v = UIScrollView()
        v.alwaysBounceVertical = true
        v.backgroundColor = .clear
        v.bounces = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var upperView: UIView = {
        let view = UIView()
        view.autoSetDimension(.height, toSize: 150)
        view.backgroundColor = UIColor(patternImage: UIImage(named: "soccer-background")!)
        return view
    }()
    lazy var overLabView: UIView = {
        let view = UIView()
        view.autoSetDimension(.height, toSize: 160)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.setUserCellShadow()
        view.backgroundColor = .white
        return view
    }()
    
    let publicLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .natural
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 2
        label.text = "Want to start\na public game"
        label.textColor = labelTextColor
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let publicButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        let image = UIImage(named: "public_game")
        button.setImage(image?.imageWithSize(CGSize(width: 75, height: 75)), for: .normal)
        button.backgroundColor = deepPurple
        button.layer.cornerRadius = 45
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let privateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .natural
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.numberOfLines = 2
        label.text = "Want to start\na private game"
        label.textColor = labelTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let privateButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tag = 0
        let image = UIImage(named: "private_game")
        button.setImage(image?.imageWithSize(CGSize(width: 75, height: 75)), for: .normal)
        button.backgroundColor = viewBackgroundColore
        button.layer.cornerRadius = 45
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let descritionTextField: UITextField = {
        let text = UITextField()
        text.textColor = labelTextColor
        text.textAlignment = .left
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.borderWidth = 1
        text.backgroundColor = .white
        text.clipsToBounds = true
        text.attributedPlaceholder = NSAttributedString(string: "Description (optional)", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .next
        text.setLeftPaddingPoints(15)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textAlignment = .natural
        label.text = "\t\t\tSTART\t\t\t\t\tEND"
        label.textColor = deepPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let endDateTextField: UITextView = {
        let text = UITextView()
        text.textColor = labelTextColor
        text.textAlignment = .natural
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.borderWidth = 1
        text.backgroundColor = .white
        text.clipsToBounds = true
        text.text = " Fri, Nov 30\n 12:00 PM"
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .next
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let startDateTextField: UITextView = {
        let text = UITextView()
        text.textColor = labelTextColor
        text.textAlignment = .center
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.borderWidth = 1
        text.backgroundColor = .white
        text.clipsToBounds = true
        text.text = "Fri, Nov 30\n08:00 AM"
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .next
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    var addressTextField: UITextField = {
        let text = UITextField()
        text.textColor = deepPurple
        text.layer.borderColor = UIColor.white.cgColor
        text.backgroundColor = .white
        text.layer.borderWidth = 1
        text.clipsToBounds = true
        text.attributedPlaceholder = NSAttributedString(string: "Address", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .next
        text.setLeftPaddingPoints(15)
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let playerNumTextField: UITextField = {
        let text = UITextField()
        text.textColor = labelTextColor
        text.backgroundColor = .white
        text.textAlignment = .center
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.borderWidth = 2
        text.clipsToBounds = true
        text.attributedPlaceholder = NSAttributedString(string: "# of Players", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .next
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let priceTextField: UITextField = {
        let text = UITextField()
        text.textColor = labelTextColor
        text.backgroundColor = .white
        text.textAlignment = .center
        text.layer.borderColor = UIColor.white.cgColor
        text.layer.borderWidth = 2
        text.clipsToBounds = true
        text.attributedPlaceholder = NSAttributedString(string: "Price per hours", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        text.font = UIFont.systemFont(ofSize: 16)
        text.returnKeyType = .next
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var skillLevelView: UIView = {
        let view = UIView()
        view.autoSetDimension(.height, toSize: 120)
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.backgroundColor = .white
        return view
    }()
    let skillLevelLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.attributedText = NSAttributedString(string: "Skill Level", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let allSkillButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.layer.cornerRadius = 10
        button.layer.borderColor = skillButtonColor
        button.layer.borderWidth = 5
        button.clipsToBounds = true
        button.backgroundColor = deepPurple
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let BeginnerButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.layer.cornerRadius = 10
        button.layer.borderColor = skillButtonColor
        button.layer.borderWidth = 5
        button.clipsToBounds = true
        button.backgroundColor = viewBackgroundColore
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let IntermediateButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.layer.cornerRadius = 10
        button.layer.borderColor = skillButtonColor
        button.layer.borderWidth = 5
        button.clipsToBounds = true
        button.backgroundColor = viewBackgroundColore
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let AdvancedButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.layer.cornerRadius = 10
        button.layer.borderColor = skillButtonColor
        button.layer.borderWidth = 5
        button.clipsToBounds = true
        button.backgroundColor = viewBackgroundColore
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let skillLabel1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "All Skill Levels", attributes: [NSAttributedString.Key.foregroundColor: deepPurple])
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let skillLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "Beginner", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let skillLabel3: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "Intermediate", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let skillLabel4: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.attributedText = NSAttributedString(string: "Advanced", attributes: [NSAttributedString.Key.foregroundColor: labelTextColor])
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let movingline: UIView = {
        let view = UIView()
        view.backgroundColor = viewBackgroundColore
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = viewBackgroundColore
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.tag = 0
        button.layer.cornerRadius = 10
        button.layer.borderColor = skillButtonColor
        button.layer.borderWidth = 5
        button.clipsToBounds = true
        button.backgroundColor = deepPurple
        button.setTitle("CREATE GAME", for: .normal)
        button.setTitleColor(viewBackgroundColore, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        
        if sender === publicButton {
            publicButton.backgroundColor = deepPurple
            publicButton.tag = 1
            privateButton.tag = 0
            privateButton.backgroundColor = viewBackgroundColore
            playerNumTextField.isHidden = false
            priceTextField.frame = CGRect(x: 0, y: 690, width: 226.6, height: 50)
            createButton.setTitle("CREATE GAME", for: .normal)
        } else if sender === privateButton {
            privateButton.backgroundColor = deepPurple
            privateButton.tag = 1
            publicButton.tag = 0
            publicButton.backgroundColor = viewBackgroundColore
            playerNumTextField.isHidden = true
            priceTextField.frame = CGRect(x: 0, y: 690, width: scrollView.frame.size.width, height: 50)
            createButton.setTitle("CONTINUE", for: .normal)
        }
    }
    @objc func skillButtonChanged(_ sender: AnyObject?){
        if sender === allSkillButton {
            allSkillButton.backgroundColor = deepPurple
            skillLabel1.tag = 1
            BeginnerButton.tag = 0
            IntermediateButton.tag = 0
            AdvancedButton.tag = 0
            BeginnerButton.backgroundColor = viewBackgroundColore
            IntermediateButton.backgroundColor = viewBackgroundColore
            AdvancedButton.backgroundColor = viewBackgroundColore
            skillLabel1.textColor = deepPurple
            skillLabel2.textColor = labelTextColor
            skillLabel3.textColor = labelTextColor
            skillLabel4.textColor = labelTextColor
            skilllevel = skillLabel1.text!
            UIView.animate(withDuration: 0.5, animations: {
                self.movingline.backgroundColor = deepPurple
                self.movingline.frame = CGRect(x:-10, y: 0, width: 5, height: 5)
                print(self.movingline.frame)
                print(self.allSkillButton.frame)
            })
            
        }else if sender === BeginnerButton {
            BeginnerButton.backgroundColor = deepPurple
            skillLabel1.tag = 0
            BeginnerButton.tag = 1
            IntermediateButton.tag = 0
            AdvancedButton.tag = 0
            allSkillButton.backgroundColor = viewBackgroundColore
            IntermediateButton.backgroundColor = viewBackgroundColore
            AdvancedButton.backgroundColor = viewBackgroundColore
            skillLabel1.textColor = labelTextColor
            skillLabel2.textColor = deepPurple
            skillLabel3.textColor = labelTextColor
            skillLabel4.textColor = labelTextColor
            skilllevel = skillLabel2.text!
            UIView.animate(withDuration: 0.5, animations: {
                self.movingline.backgroundColor = deepPurple
                self.movingline.frame = CGRect(x: 85, y: self.movingline.frame.origin.y, width: 5, height: 5)
                print(self.movingline.frame)
            })
            
        }else if sender === IntermediateButton {
            IntermediateButton.backgroundColor = deepPurple
            skillLabel1.tag = 0
            BeginnerButton.tag = 0
            IntermediateButton.tag = 1
            AdvancedButton.tag = 0
            allSkillButton.backgroundColor = viewBackgroundColore
            BeginnerButton.backgroundColor = viewBackgroundColore
            AdvancedButton.backgroundColor = viewBackgroundColore
            skillLabel1.textColor = labelTextColor
            skillLabel2.textColor = labelTextColor
            skillLabel3.textColor = deepPurple
            skillLabel4.textColor = labelTextColor
            skilllevel = skillLabel3.text!
            UIView.animate(withDuration: 0.5, animations: {
                self.movingline.backgroundColor = deepPurple
                self.movingline.frame = CGRect(x:190, y: self.movingline.frame.origin.y, width: 5, height: 5)
                print(self.movingline.frame)
            })
            
        }else if sender === AdvancedButton {
            AdvancedButton.backgroundColor = deepPurple
            skillLabel1.tag = 0
            BeginnerButton.tag = 0
            IntermediateButton.tag = 0
            AdvancedButton.tag = 1
            allSkillButton.backgroundColor = viewBackgroundColore
            BeginnerButton.backgroundColor = viewBackgroundColore
            IntermediateButton.backgroundColor = viewBackgroundColore
            skillLabel1.textColor = labelTextColor
            skillLabel2.textColor = labelTextColor
            skillLabel3.textColor = labelTextColor
            skillLabel4.textColor = deepPurple
            skilllevel = skillLabel4.text!
            self.movingline.needsUpdateConstraints()
            UIView.animate(withDuration: 0.5, animations: {
                self.movingline.backgroundColor = deepPurple
                self.movingline.frame = CGRect(x:295, y: self.movingline.frame.origin.y, width: 5, height: 5)
                print(self.movingline.frame)
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.title = "Create New Game"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        
        setupViews()
        priceTextField.frame = CGRect(x: 0, y: 690, width: 226.6, height: 50)
        playerNumTextField.isHidden = false
        self.MydatePicker()
        self.MytimePicker()
        
        addressTextField.delegate = self
        
        publicButton.isSelected = true
        publicButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        privateButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        
        allSkillButton.addTarget(self, action: #selector(skillButtonChanged(_:)), for: .touchUpInside)
        BeginnerButton.addTarget(self, action: #selector(skillButtonChanged(_:)), for: .touchUpInside)
        IntermediateButton.addTarget(self, action: #selector(skillButtonChanged(_:)), for: .touchUpInside)
        AdvancedButton.addTarget(self, action: #selector(skillButtonChanged(_:)), for: .touchUpInside)
        
        createButton.addTarget(self, action: #selector(saveNewEvent), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func MydatePicker(){
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)),
                             for: UIControl.Event.valueChanged)

        startDateTextField.inputView = datePicker
        let currentDate: Date = Date()
        datePicker.minimumDate = currentDate
        datePicker.backgroundColor = .white
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 40 ))
        toolbar.barTintColor = deepPurple
        toolbar.tintColor = UIColor.white
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain,
                                          target: self, action:
            #selector(todayPressed(sender:)))
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain,
                                         target: self, action:
            #selector(DateDonePressed(sender:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace
            , target: self, action: nil)
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 40))
        lable.textColor = UIColor.white
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Set Start Date"
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        let labelButton = UIBarButtonItem(customView: lable)
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        startDateTextField.inputAccessoryView = toolbar
    }
    
    @objc func DateDonePressed(sender: UIBarButtonItem){
        startDateTextField.resignFirstResponder()
    }
    
    var timeAndDate = String()
    var startDate = Date()
    @objc func todayPressed(sender: UIBarButtonItem){
        let data = NSDate() as Date
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd\nh:mma"
        timeAndDate = formatter.string(from: data)
        startDateTextField.text = timeAndDate
        startDateTextField.resignFirstResponder()
        startDate = data
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker){
        startDate = sender.date
        let  formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd\nh:mma"
        timeAndDate = formatter.string(from: sender.date)
        startDateTextField.text = timeAndDate
    }
    
    func MytimePicker(){
        timePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        timePicker.addTarget(self, action: #selector(timePickerValueChanged(sender:)),
                             for: UIControl.Event.valueChanged)
        endDateTextField.inputView = timePicker
        
        let currentDate: Date = Date()
        timePicker.minimumDate = currentDate
        timePicker.backgroundColor = .white
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 40 ))
        toolbar.barTintColor = deepPurple
        toolbar.tintColor = UIColor.white
        let todayButton = UIBarButtonItem(title: "Today", style: UIBarButtonItem.Style.plain,
                                          target: self, action:
            #selector(donePressed(sender:)))
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain,
                                         target: self, action:
            #selector(TimeDonePressed(sender:)))
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace
            , target: self, action: nil)
        let lable = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/3, height: 40))
        lable.textColor = UIColor.white
        lable.textAlignment = NSTextAlignment.center
        lable.text = "Set End Date"
        lable.font = UIFont.boldSystemFont(ofSize: 14)
        let labelButton = UIBarButtonItem(customView: lable)
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        endDateTextField.inputAccessoryView = toolbar
    }
    var endDate = Date()
    @objc func TimeDonePressed(sender: UIBarButtonItem){
        endDateTextField.resignFirstResponder()
    }
    @objc func donePressed(sender: UIBarButtonItem){
        let data = NSDate() as Date
        let  formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd\nh:mma"
        let timeAndDate = formatter.string(from: data)
        print(timeAndDate)
        endDateTextField.text = timeAndDate
        endDateTextField.resignFirstResponder()
        endDate = data
    }
    @objc func timePickerValueChanged(sender: UIDatePicker){
        endDate = sender.date
        let  formatter = DateFormatter()
        formatter.dateFormat = "E, MMM dd\nh:mma"
        let timeAndDate = formatter.string(from: sender.date)
        print(timeAndDate)
        endDateTextField.text = timeAndDate
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
        
    }
    @objc func saveNewEvent() {
        
        if publicButton.tag == 1 {
            print("public event has been saved")
            if startDateTextField.text == "" || endDateTextField.text == "" || addressTextField.text == "" || priceTextField.text == "" || playerNumTextField.text == "" {

                let alert = UIAlertController(title: "WORNING", message: "You must complete all fields.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else if startDateTextField.text == endDateTextField.text {
                let alert = UIAlertController(title: "WORNING", message: "End Date sould not be less then Start date.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let publicGame = PFObject (className: EVENT_CLASS_NAME)
                publicGame["location"] = addressTextField.text
                publicGame["startTime"] = startDateTextField.text.replacingOccurrences(of: "\n", with: ", ")
                publicGame["endTime"] = endDateTextField.text.replacingOccurrences(of: "\n", with: ", ")
                publicGame["gameStartTime"] = startDate
                publicGame["gameEndTime"] = endDate
                publicGame["price"] = "$\(priceTextField.text ?? "")"
                publicGame["GameCost"] = Int(priceTextField.text!)
                publicGame["user"] = PFUser.current()?.username
                publicGame.addObjects(from: [PFUser.current()!], forKey: "player")
                publicGame.setObject(PFUser.current()!, forKey: "CreatedBy")
                publicGame["counts"] = Int(playerNumTextField.text!)
                publicGame["joined"] = 1
                publicGame["userImage"] = PFUser.current()?.value(forKey: "profileImage")
                let myGeoPoint = PFGeoPoint(latitude: latitude!, longitude: longitude!)
                publicGame["coordinate"] = myGeoPoint
                publicGame["locationName"] = locationName
                publicGame["city"] = locality
                publicGame["skillLevel"] = skilllevel
                publicGame[GAME_TYPE] = "Public"
                publicGame.saveInBackground{ (success: Bool , error: Error?) -> Void in
                    if (success) {
                        print("success")
                        DispatchQueue.main.async {
                            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ToHomePage")
                            self.present(viewController, animated: true, completion: nil)
                            
                        }
                        
                    }else{
                        print(error as Any)
                        
                    }
                    
                }
            }
        }else if privateButton.tag == 1 {
            print("private event has been saved")
            if startDateTextField.text == "" || endDateTextField.text == "" || addressTextField.text == "" || priceTextField.text == "" {
                let alert = UIAlertController(title: "Alert", message: "You must complete all fields.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else if startDateTextField.text == endDateTextField.text {
                let alert = UIAlertController(title: "WORNING", message: "End Date sould not be less then Start date.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let vc = NewTeam()
                vc.address = addressTextField.text!
                vc.price = priceTextField.text!
                vc.startTime = startDateTextField.text
                vc.endTime = endDateTextField.text
                vc.skilllevel = skilllevel
                vc.locality = locality
                vc.locationName = locationName!
                vc.latitude = latitude!
                vc.longitude = longitude!
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    func addObservers(){
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillShow(notification: notification)
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) {
            notification in
            self.keyboardWillHide(notification: notification)
        }
    }
    
    func removeObservers(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardWillShow(notification: Notification){
        guard let userInfo = notification.userInfo,
            let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
        }
        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: frame.height, right: 0)
        scrollView.contentInset = contentInset
    }
    func keyboardWillHide(notification: Notification){
        scrollView.contentInset = .zero
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension NewEventVC {
    
    func setupViews(){
        
        view.addSubview(scrollView)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        scrollView.addSubview(upperView)
        scrollView.addSubview(overLabView)
        scrollView.bringSubviewToFront(overLabView)
        scrollView.addSubview(descritionTextField)
        scrollView.addSubview(headerLabel)
        scrollView.addSubview(startDateTextField)
        scrollView.addSubview(endDateTextField)
        scrollView.addSubview(addressTextField)
        scrollView.addSubview(playerNumTextField)
        scrollView.addSubview(priceTextField)
        scrollView.addSubview(skillLevelView)
        scrollView.addSubview(createButton)
        
        upperView.autoPinEdge(toSuperviewEdge: .left)
        upperView.autoPinEdge(toSuperviewEdge: .right)
        upperView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .bottom)
        
        overLabView.addSubview(publicButton)
        overLabView.addSubview(privateButton)
        overLabView.addSubview(publicLabel)
        overLabView.addSubview(privateLabel)
        overLabView.autoAlignAxis(toSuperviewAxis: .vertical)
        overLabView.autoPinEdge(toSuperviewEdge: .top, withInset: 120.0)
        overLabView.autoPinEdge(toSuperviewEdge: .left, withInset: 10.0)
        overLabView.autoPinEdge(toSuperviewEdge: .right, withInset: 10.0)
        
        
        publicButton.topAnchor.constraint(equalTo: overLabView.topAnchor, constant: 8).isActive = true
        publicButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        publicButton.leftAnchor.constraint(equalTo: overLabView.leftAnchor, constant: 30).isActive = true
        publicButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        privateButton.centerYAnchor.constraint(equalTo: publicButton.centerYAnchor).isActive = true
        privateButton.topAnchor.constraint(equalTo: overLabView.topAnchor, constant: 8).isActive = true
        privateButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        privateButton.rightAnchor.constraint(equalTo: overLabView.rightAnchor, constant: -30).isActive = true
        privateButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        publicLabel.topAnchor.constraint(equalTo: publicButton.bottomAnchor, constant: 8).isActive = true
        publicLabel.centerXAnchor.constraint(equalTo: publicButton.centerXAnchor).isActive = true
        
        privateLabel.topAnchor.constraint(equalTo: privateButton.bottomAnchor, constant: 8).isActive = true
        privateLabel.centerXAnchor.constraint(equalTo: privateButton.centerXAnchor).isActive = true
        
        descritionTextField.centerXAnchor.constraint(equalTo: overLabView.centerXAnchor).isActive = true
        descritionTextField.topAnchor.constraint(equalTo: overLabView.bottomAnchor, constant: 20).isActive = true
        descritionTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        descritionTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        headerLabel.topAnchor.constraint(equalTo: descritionTextField.bottomAnchor, constant: 20).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        headerLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        startDateTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor).isActive = true
        startDateTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        startDateTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        
        endDateTextField.centerYAnchor.constraint(equalTo: startDateTextField.centerYAnchor).isActive = true
        endDateTextField.leftAnchor.constraint(equalTo: startDateTextField.rightAnchor).isActive = true
        endDateTextField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        endDateTextField.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        endDateTextField.widthAnchor.constraint(equalToConstant: 187.5).isActive = true
        
        addressTextField.topAnchor.constraint(equalTo: startDateTextField.bottomAnchor).isActive = true
        addressTextField.centerXAnchor.constraint(equalTo: descritionTextField.centerXAnchor).isActive = true
        addressTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        
        
        skillLevelView.addSubview(skillLevelLabel)
        line.addSubview(movingline)
        skillLevelView.addSubview(allSkillButton)
        skillLevelView.addSubview(line)
        skillLevelView.addSubview(BeginnerButton)
        skillLevelView.addSubview(IntermediateButton)
        skillLevelView.addSubview(AdvancedButton)
        skillLevelView.addSubview(skillLabel1)
        skillLevelView.addSubview(skillLabel2)
        skillLevelView.addSubview(skillLabel3)
        skillLevelView.addSubview(skillLabel4)
        
        skillLevelView.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 20).isActive = true
        skillLevelView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        skillLevelView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        
        skillLevelLabel.topAnchor.constraint(equalTo: skillLevelView.topAnchor, constant: 8).isActive = true
        skillLevelLabel.leftAnchor.constraint(equalTo: skillLevelView.leftAnchor).isActive = true
        skillLevelLabel.rightAnchor.constraint(equalTo: skillLevelView.rightAnchor).isActive = true
        skillLevelLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        allSkillButton.topAnchor.constraint(equalTo: skillLevelLabel.topAnchor, constant: 30).isActive = true
        allSkillButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        allSkillButton.leftAnchor.constraint(equalTo: skillLevelView.leftAnchor, constant: 40).isActive = true
        allSkillButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        movingline.autoPinEdge(.top, to: .top, of: line)
        movingline.autoPinEdge(.left, to: .left, of: line)
        movingline.autoSetDimension(.height, toSize: 5)
        movingline.autoSetDimension(.width, toSize: 85)
        
        line.centerYAnchor.constraint(equalTo: allSkillButton.centerYAnchor).isActive = true
        line.leftAnchor.constraint(equalTo: allSkillButton.rightAnchor).isActive = true
        line.widthAnchor.constraint(equalToConstant: 295).isActive = true
        line.heightAnchor.constraint(equalToConstant: 5).isActive = true
        
        BeginnerButton.leftAnchor.constraint(equalTo: allSkillButton.rightAnchor, constant: 85).isActive = true
        BeginnerButton.centerYAnchor.constraint(equalTo: allSkillButton.centerYAnchor).isActive = true
        BeginnerButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        BeginnerButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        IntermediateButton.leftAnchor.constraint(equalTo: BeginnerButton.rightAnchor, constant: 85).isActive = true
        IntermediateButton.centerYAnchor.constraint(equalTo: allSkillButton.centerYAnchor).isActive = true
        IntermediateButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        IntermediateButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        AdvancedButton.leftAnchor.constraint(equalTo: IntermediateButton.rightAnchor, constant: 85).isActive = true
        AdvancedButton.centerYAnchor.constraint(equalTo: allSkillButton.centerYAnchor).isActive = true
        AdvancedButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        AdvancedButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        skillLabel1.centerXAnchor.constraint(equalTo: allSkillButton.centerXAnchor).isActive = true
        skillLabel1.topAnchor.constraint(equalTo: allSkillButton.bottomAnchor, constant: 4).isActive = true
        
        skillLabel2.centerXAnchor.constraint(equalTo: BeginnerButton.centerXAnchor).isActive = true
        skillLabel2.topAnchor.constraint(equalTo: BeginnerButton.bottomAnchor, constant: 4).isActive = true
        
        skillLabel3.centerXAnchor.constraint(equalTo: IntermediateButton.centerXAnchor).isActive = true
        skillLabel3.topAnchor.constraint(equalTo: IntermediateButton.bottomAnchor, constant: 4).isActive = true
        
        skillLabel4.centerXAnchor.constraint(equalTo: AdvancedButton.centerXAnchor).isActive = true
        skillLabel4.topAnchor.constraint(equalTo: AdvancedButton.bottomAnchor, constant: 4).isActive = true
        
        priceTextField.topAnchor.constraint(equalTo: skillLevelView.bottomAnchor, constant: 20).isActive = true
        priceTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        priceTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        
        playerNumTextField.centerYAnchor.constraint(equalTo: priceTextField.centerYAnchor).isActive = true
        playerNumTextField.leftAnchor.constraint(equalTo: priceTextField.rightAnchor).isActive = true
        playerNumTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playerNumTextField.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        playerNumTextField.widthAnchor.constraint(equalToConstant: 187.5).isActive = true
        
        createButton.topAnchor.constraint(equalTo: playerNumTextField.bottomAnchor, constant: 20).isActive = true
        createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10).isActive = true
        createButton.centerXAnchor.constraint(equalTo: descritionTextField.centerXAnchor).isActive = true
        createButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -24).isActive = true
        createButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
extension NewEventVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        _ = place.placeID
        self.locationName = place.name
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n")  ?? " ")")
        self.addressTextField.text = place.formattedAddress?.components(separatedBy: ", ")
            .joined(separator: "\n")
        print("Place attributions: \(String(describing: place.attributions))")
        self.latitude = place.coordinate.latitude
        self.longitude = place.coordinate.longitude
        
        // Get the address components.
        if let addressLines = place.addressComponents {
            // Populate all of the address fields we can find.
            for field in addressLines {
                switch field.type {
                case kGMSPlaceTypeStreetNumber:
                    street_number = field.name
                case kGMSPlaceTypeRoute:
                    route = field.name
                case kGMSPlaceTypeNeighborhood:
                    neighborhood = field.name
                case kGMSPlaceTypeLocality:
                    locality = field.name
                case kGMSPlaceTypeAdministrativeAreaLevel1:
                    administrative_area_level_1 = field.name
                case kGMSPlaceTypeCountry:
                    country = field.name
                case kGMSPlaceTypePostalCode:
                    postal_code = field.name
                case kGMSPlaceTypePostalCodeSuffix:
                    postal_code_suffix = field.name
                // Print the items we aren't using.
                default:
                    print("Type: \(field.type), Name: \(field.name)")
                }
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}
