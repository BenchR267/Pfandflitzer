//
//  UIButton.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit

extension UIButton {
    
    var title: String {
        get {
            return titleLabel?.text ?? ""
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }
    
}
