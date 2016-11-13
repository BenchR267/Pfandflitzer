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
    @IBOutlet weak var ctaButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create offer"
        
        nameTextField.rx.text.subscribe(onNext: { [weak self] t in
            self?.model.name = t
        }).addDisposableTo(self.disposeBag)
        
        mailTextField.rx.text.subscribe(onNext: { [weak self] t in
            self?.model.mail = t
        }).addDisposableTo(self.disposeBag)
        
        model.canUpload.bindTo(ctaButton.rx.isEnabled).addDisposableTo(disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func ctaPressed(_ sender: UIButton) {
        // TODO: Save, Post and close
        model.post().subscribe(onNext: { [weak self] o in
            print("\(o)")
            if o != nil {
                self?.dismiss()
            }
            }, onError: {
                print($0)
        }).addDisposableTo(self.disposeBag)
        
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss()
    }

}
