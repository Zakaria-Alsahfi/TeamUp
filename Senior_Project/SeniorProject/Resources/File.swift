//
//  File.swift
//  SeniorProject
//
//  Created by zakaria alsahfi on 9/4/18.
//  Copyright © 2018 zakaria alsahfi. All rights reserved.
//

import Foundation

class Responder: NSObject {
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        UIView.animate(withDuration: 0.3) {
            buttonBar.frame.origin.x = (segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)) * CGFloat(segmentedControl.selectedSegmentIndex)
        }
    }
}
