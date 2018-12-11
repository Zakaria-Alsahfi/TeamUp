//
//  HostingGamesCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/21/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class HostingGamesCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.clipsToBounds = true
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
        label.text = " "
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
    
    let filledStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = UIColor.yellow
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    let requesteStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = NSLayoutConstraint.Axis.vertical
        sv.backgroundColor = .gray
        sv.alignment = UIStackView.Alignment.center
        sv.distribution = UIStackView.Distribution.fillEqually
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
        self.setUserCellShadow()

        addSubview(imageView)
        addSubview(statesLabel)
        bringSubviewToFront(statesLabel)
        addSubview(overLabView)
        bringSubviewToFront(overLabView)
        addSubview(locationLabel)
        addSubview(gameNameLabel)
        
        
        addSubview(skillLabel)
        addSubview(skill)
        addSubview(skillStackView)
        
        addSubview(filledLabel)
        addSubview(filled)
        addSubview(filledStackView)
        
        addSubview(requesteLabel)
        addSubview(requeste)
        addSubview(requesteStackView)
        
        addSubview(parentStackView)
        
        overLabView.addSubview(dateLabel)
        
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
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
        locationLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        gameNameLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        gameNameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        gameNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gameNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        
        skillStackView.addArrangedSubview(skillLabel)
        skillStackView.addArrangedSubview(skill)
        
        filledStackView.addArrangedSubview(filledLabel)
        filledStackView.addArrangedSubview(filled)
        
        requesteStackView.addArrangedSubview(requesteLabel)
        requesteStackView.addArrangedSubview(requeste)
        
        parentStackView.addArrangedSubview(skillStackView)
        parentStackView.addArrangedSubview(filledStackView)
        parentStackView.addArrangedSubview(requesteStackView)
        
        parentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        parentStackView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        parentStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        parentStackView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}
