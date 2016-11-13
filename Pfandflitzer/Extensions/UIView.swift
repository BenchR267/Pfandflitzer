//
//  UIView.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit

extension UIView {
    
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder {
            return self
        }
        
        for s in subviews {
            if let v = s.findFirstResponder() {
                return v
            }
        }
        return nil
    }
    
}
