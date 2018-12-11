//
//  InvitedGamesCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/21/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class InvitedGamesCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.image = UIImage(named: "soccer-background")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let statesLabel: UILabel = {
        let label = UILabel()
        label.autoSetDimension(.height, toSize: 30)
        label.autoSetDimension(.width, toSize: 100)
        label.text = "PAST"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.backgroundColor = UIColor(red:0.96, green:0.35, blue:0.44, alpha:1.0)
        label.textAlignment = .center
        return label
    }()
    
    let overLabView: UIView = {
        let view = UIView()
        view.autoSetDimension(.height, toSize: 35)
        view.autoSetDimension(.width, toSize: 130)
        view.backgroundColor = UIColor(red: 74.0/255.0, green: 65.0/255.0, blue: 135.0/255.0, alpha: 0.9)
        return view
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Nov 30,2018"
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Fontbonne University"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gameNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Fontbonne Student"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let skillLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = deepPurple
        label.text = "Skill level"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let skill: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Intermediate"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filledLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Filled"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let filled: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "5"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requesteLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "Requestes"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let requeste: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "8"
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
    
    let goingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = deepPurple
        button.setTitle("GOING", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let notGoingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = deepPurple
        button.setTitle("NOT GOING", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.horizontal
        sv.backgroundColor = .clear
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.spacing = 1
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
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
        
        addSubview(imageView)
        addSubview(statesLabel)
        bringSubviewToFront(statesLabel)
        addSubview(overLabView)
        bringSubviewToFront(overLabView)
        addSubview(locationLabel)
        addSubview(gameNameLabel)
        addSubview(skillLabel)
        addSubview(skill)
        addSubview(filledLabel)
        addSubview(filled)
        addSubview(requesteLabel)
        addSubview(requeste)
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        addSubview(goingButton)
        addSubview(notGoingButton)
        addSubview(stackView)
        
        overLabView.addSubview(dateLabel)
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        statesLabel.leftAnchor.constraint(equalTo: leftAnchor,constant: 15).isActive = true
        statesLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        
        overLabView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        overLabView.topAnchor.constraint(equalTo: topAnchor, constant: 110).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: overLabView.topAnchor, constant: 1).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: overLabView.rightAnchor, constant: -2).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        dateLabel.widthAnchor.constraint(equalTo: overLabView.widthAnchor).isActive = true
        
        locationLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        locationLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        gameNameLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        gameNameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        gameNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gameNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        skillLabel.topAnchor.constraint(equalTo: topAnchor, constant: 110).isActive = true
        skillLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20).isActive = true
        skillLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        skillLabel.rightAnchor.constraint(equalTo: filledLabel.leftAnchor, constant: -60).isActive = true
        
        skill.centerXAnchor.constraint(equalTo: skillLabel.centerXAnchor).isActive = true
        skill.topAnchor.constraint(equalTo: skillLabel.bottomAnchor, constant: 2).isActive = true
        skill.heightAnchor.constraint(equalToConstant: 15).isActive = true
        skill.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        
        filledLabel.centerYAnchor.constraint(equalTo: skillLabel.centerYAnchor).isActive = true
        filledLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        filledLabel.rightAnchor.constraint(equalTo: requesteLabel.leftAnchor, constant: -30).isActive = true
        
        filled.centerXAnchor.constraint(equalTo: filledLabel.centerXAnchor).isActive = true
        filled.topAnchor.constraint(equalTo: filledLabel.bottomAnchor, constant: 2).isActive = true
        filled.heightAnchor.constraint(equalToConstant: 15).isActive = true
        filled.leftAnchor.constraint(equalTo: skill.rightAnchor, constant: 60).isActive = true
        
        requesteLabel.centerYAnchor.constraint(equalTo: filledLabel.centerYAnchor).isActive = true
        requesteLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        requesteLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        requeste.centerXAnchor.constraint(equalTo: requesteLabel.centerXAnchor).isActive = true
        requeste.topAnchor.constraint(equalTo: requesteLabel.bottomAnchor, constant: 2).isActive = true
        requeste.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        topSeparatorView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 1).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        stackView.addArrangedSubview(goingButton)
        stackView.addArrangedSubview(notGoingButton)
        
        stackView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 49).isActive = true
        
        bottomSeparatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
}
