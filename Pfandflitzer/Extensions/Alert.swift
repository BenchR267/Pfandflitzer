//
//  Alert.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 13/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit

class Alert {
    
    let message: String
    var actions = [UIAlertAction]()
    
    init(message: String) {
        self.message = message
    }
    
    func action(title: String, handler: @escaping () -> Void) -> Alert {
        actions.append(UIAlertAction(title: title, style: .default, handler: { _ in
            handler()
        }))
        return self
    }
    
    func show(on controller: UIViewController) {
        let a = UIAlertController(title: "", message: message, preferredStyle: .alert)
        actions.forEach(a.addAction)
        controller.present(a, animated: true, completion: nil)
    }
    
}
