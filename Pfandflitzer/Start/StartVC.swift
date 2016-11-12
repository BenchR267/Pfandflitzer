//
//  StartVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit

class StartVC: ViewController {

    @IBOutlet weak var searchButton: UIButton! {
        didSet {
            searchButton.title = "START_SEARCH_BUTTON".localized
        }
    }
    @IBOutlet weak var offerButton: UIButton! {
        didSet {
            offerButton.title = "START_OFFER_BUTTON".localized
        }
    }
    
    
}
