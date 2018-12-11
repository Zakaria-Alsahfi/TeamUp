//
//  ReusableHeaderView.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 10/29/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import UIKit

class ReusableHeaderView: UICollectionViewCell {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .left
        label.layer.masksToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(nameLabel)
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
