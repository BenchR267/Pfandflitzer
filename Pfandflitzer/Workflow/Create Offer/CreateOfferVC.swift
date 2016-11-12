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
import CoreLocation

class CreateOfferModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    dynamic var image: UIImage?
    dynamic var note = ""
    dynamic var box = 0.0
    dynamic var bag = 0.0
    
    dynamic var name: String?
    dynamic var mail: String?
    
    dynamic var location: CLLocation? {
        didSet {
            let loc = Location(location: location!)
            Offer.get(location: loc)
                .subscribe(onNext: {
                    print("\($0)")
                }, onError: {
                    print($0)
                })
                .addDisposableTo(disposeBag)
        }
    }
    
    var imageObservable: Observable<UIImage> {
        return self.rx.observe(UIImage.self, "image").map { $0 ?? UIImage(named: "camera")! }
    }
    
    var locationObservable: Observable<CLLocation?> {
        return self.rx.observe(CLLocation.self, "location")
    }
    
    var noteObservable: Observable<String> {
        return self.rx.observe(String.self, "note").filterNil()
    }
    
    var nameObservable: Observable<String> {
        return self.rx.observe(String.self, "name").filterNil()
    }
    
    var mailObservable: Observable<String> {
        return self.rx.observe(String.self, "mail").filterNil()
    }
    
    var firstStepDone: Observable<Bool> {
        return Observable.combineLatest(locationObservable, self.rx.observe(UIImage.self, "image")) {
            return $0 != nil && $1 != nil
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GetLocation().get().subscribe(onNext: { [weak self] l in
            self?.model.location = l
        }).addDisposableTo(disposeBag)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as? CreateOfferPersonVC)?.model = model
    }

    @IBAction func nextButtonPressed(_ sender: UIButton) {
        
    }
}
