//
//  CreateOfferVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateOfferModel: NSObject {
    
    dynamic var image: UIImage?
    var note = ""
    var box = 0.0
    var bag = 0.0
    
    var imageObservable: Observable<UIImage> {
        return self.rx.observe(UIImage.self, "image").map { $0 ?? UIImage(named: "camera")! }
    }
    
    var firstStepDone: Observable<Bool> {
        return self.rx.observe(UIImage.self, "image").map { $0 != nil }
    }
    
}

class CreateOfferVC: ViewController {

    let disposeBag = DisposeBag()
    
    let model = CreateOfferModel()
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let g = UITapGestureRecognizer()
            g.rx.event.subscribe { [weak self] r in
                guard let `self` = self else { return }
                TakePhoto().show(on: self).subscribe(onNext: { image in
                    self.model.image = image
                }).addDisposableTo(self.disposeBag)
            }.addDisposableTo(self.disposeBag)
            imageView.addGestureRecognizer(g)
            imageView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var noteTextView: UITextView! {
        didSet {
            noteTextView.text = ""
        }
    }
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.title = "NEXT_BUTTON".localized
            model.firstStepDone
                .bindTo(nextButton.rx.isEnabled)
                .addDisposableTo(disposeBag)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.imageObservable.bindTo(imageView.rx.image).addDisposableTo(disposeBag)
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
}
