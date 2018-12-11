//
//  Player.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/5/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//
import UIKit

class Player: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "pall")
        iv.layer.cornerRadius = 25
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = deepPurple
        label.text = "Zakaria"
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        setUserCellShadow()
        addSubview(imageView)
        addSubview(nameLabel)
        
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
    }

}
