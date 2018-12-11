//
//  EventsCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/5/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit
import MapKit
import Parse
import ParseUI

class EventsCell: UICollectionViewCell {
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Sep,5th,2018"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 30
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let pricePerHourLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = deepPurple
        label.textColor = .white
        label.textAlignment = .center
        label.layer.borderColor = labelColor
        label.layer.shadowColor =  labelColor
        label.layer.cornerRadius = 15
        label.layer.shadowRadius =  4.0
        label.layer.shadowOpacity = 0.9
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        label.layer.masksToBounds = false
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backGroundImage: UIImageView = {
       let image = UIImageView()
        image.contentMode =  UIView.ContentMode.scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 15
        image.alpha = 0.4
        image.image = UIImage(named: "soccer-background")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    func addViews(){
        setCellShadow()
        backgroundColor = deepPurple
        
        addSubview(profileImageButton)
        addSubview(nameLabel)
        addSubview(distanceLabel)
        addSubview(pricePerHourLabel)
        addSubview(timeLabel)
        addSubview(topSeparatorView)
        addSubview(backGroundImage)
        sendSubviewToBack(backGroundImage)
        
        backGroundImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backGroundImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backGroundImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backGroundImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        backGroundImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        topSeparatorView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 1).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        profileImageButton.topAnchor.constraint(equalTo: topSeparatorView.topAnchor, constant: 10).isActive = true
        profileImageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 10).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: profileImageButton.centerXAnchor).isActive = true
        
        pricePerHourLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        
        pricePerHourLabel.centerXAnchor.constraint(equalTo: profileImageButton.centerXAnchor).isActive = true

        distanceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        distanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        distanceLabel.topAnchor.constraint(equalTo: pricePerHourLabel.bottomAnchor, constant: 25).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
