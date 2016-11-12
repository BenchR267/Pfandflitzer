//
//  CreateOfferPersonVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import RxSwift

class CreateOfferPersonVC: ViewController {

    var disposeBag = DisposeBag()
    var model: CreateOfferModel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            model.name = nameTextField.text
        }
    }
    
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var mailTextField: UITextField! {
        didSet {
            model.mail = mailTextField.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.nameObservable.bindTo(nameTextField.rx.text).addDisposableTo(disposeBag)
        model.mailObservable.bindTo(mailTextField.rx.text).addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func ctaPressed(_ sender: UIButton) {
        // TODO: Save, Post and close
        dismiss()
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss()
    }

}
