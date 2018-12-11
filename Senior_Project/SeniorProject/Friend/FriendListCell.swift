//
//  FriendListCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 6/9/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class FriendListCell: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.clipsToBounds = true
        image.image = UIImage(named: "pall")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = deepPurple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = deepPurple
        button.setTitle("Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addViews() {
        
        setUserCellShadow()
        
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(messageButton)
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        messageButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        messageButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        messageButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        messageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        messageButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
}
