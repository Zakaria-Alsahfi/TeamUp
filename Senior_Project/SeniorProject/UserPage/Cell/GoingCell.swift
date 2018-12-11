//
//  GoingCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/30/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class GoingCell: UICollectionViewCell {
    
    let profileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
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
    
    
    let LocationLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Fontbonne University"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gameImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "GameImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let gameNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Fontbonne Student"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let topSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let skillImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "skill")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "All Skill Levels"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "calendar")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Nov 30, 9:00PM"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.image = UIImage(named: "ticket")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "20"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let parentStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.backgroundColor = .white
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.equalSpacing
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let skillStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = .green
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = UIColor.yellow
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let priceStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = .gray
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    let statesLabel: UILabel = {
        let label = UILabel()
        label.autoSetDimension(.height, toSize: 30)
        label.autoSetDimension(.width, toSize: 150)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.backgroundColor = UIColor(red:0.96, green:0.35, blue:0.44, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
        label.autoSetDimension(.height, toSize: 30)
        label.autoSetDimension(.width, toSize: 150)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews(){
        backgroundColor = .white
        self.setUserCellShadow()
        addSubview(profileImage)
        addSubview(nameLabel)
        addSubview(LocationLabel)
        addSubview(gameImage)
        addSubview(gameNameLabel)
        addSubview(statesLabel)
        bringSubviewToFront(statesLabel)
        
        addSubview(skillImage)
        addSubview(skillLabel)
        addSubview(skillStackView)
        
        addSubview(timeImage)
        addSubview(timeLabel)
        addSubview(timeStackView)
        
        addSubview(priceImage)
        addSubview(priceLabel)
        addSubview(priceStackView)
        
        addSubview(parentStackView)
        statesLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        statesLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: -15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        LocationLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
        LocationLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor, constant: 8).isActive = true
        LocationLabel.widthAnchor.constraint(equalToConstant: 300)
    
        
        gameImage.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
        gameImage.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        gameImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        gameNameLabel.topAnchor.constraint(equalTo: gameImage.bottomAnchor, constant: 10).isActive = true
        gameNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        skillStackView.addArrangedSubview(skillImage)
        skillImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        skillStackView.addArrangedSubview(skillLabel)
        
        timeStackView.addArrangedSubview(timeImage)
        timeImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        timeStackView.addArrangedSubview(timeLabel)
        
        priceStackView.addArrangedSubview(priceImage)
        priceImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        priceStackView.addArrangedSubview(priceLabel)
        
        parentStackView.addArrangedSubview(skillStackView)
        parentStackView.addArrangedSubview(timeStackView)
        parentStackView.addArrangedSubview(priceStackView)
        
        parentStackView.topAnchor.constraint(equalTo: gameNameLabel.bottomAnchor, constant: 10).isActive = true
        parentStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        parentStackView.widthAnchor.constraint(equalToConstant: 330).isActive = true
        parentStackView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
}
