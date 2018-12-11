//
//  InvitedCell.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/28/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class InvitedCell: UICollectionViewCell {
    
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
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Nov 30, 9:00PM"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = deepPurple
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "20"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .clear
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.cornerRadius = 25
        image.image = UIImage(named: "soccer-background")
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
        addSubview(statesLabel)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(LocationLabel)
        addSubview(timeLabel)
        addSubview(priceLabel)
        addSubview(topSeparatorView)
        addSubview(bottomSeparatorView)
        addSubview(goingButton)
        addSubview(notGoingButton)
        addSubview(stackView)
        
        
        statesLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        statesLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        imageView.topAnchor.constraint(equalTo: statesLabel.bottomAnchor, constant: 10).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: -15).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        LocationLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 10).isActive = true
        LocationLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 8).isActive = true
        LocationLabel.widthAnchor.constraint(equalToConstant: 300)
        
        timeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        timeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -100).isActive = true
        
        priceLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 10).isActive = true
        priceLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        priceLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        topSeparatorView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4).isActive = true
        topSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        topSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        stackView.addArrangedSubview(goingButton)
        stackView.addArrangedSubview(notGoingButton)
        
        stackView.topAnchor.constraint(equalTo: topSeparatorView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomSeparatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        bottomSeparatorView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
