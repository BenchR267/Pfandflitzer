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
import RxKeyboard

class CreateOfferModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    dynamic var image: UIImage?
    dynamic var note = ""
    dynamic var box = 0
    dynamic var bag = 0
    
    dynamic var name: String?
    dynamic var mail: String?
    
    dynamic var location: CLLocation?
    
    var imageObservable: Observable<UIImage> {
        return self.rx.observe(UIImage.self, "image").map { $0 ?? UIImage(named: "camera")! }
    }
    
    var locationObservable: Observable<CLLocation?> {
        return self.rx.observe(CLLocation.self, "location")
    }
    
    var noteObservable: Observable<String> {
        return self.rx.observe(String.self, "note").filterNil()
    }
    
    var nameObservable: Observable<String?> {
        return self.rx.observe(String.self, "name")
    }
    
    var mailObservable: Observable<String?> {
        return self.rx.observe(String.self, "mail")
    }
    
    var firstStepDone: Observable<Bool> {
        return Observable.combineLatest(locationObservable, self.rx.observe(UIImage.self, "image"), self.rx.observe(Int.self, "box"), self.rx.observe(Int.self, "bag")) {
            return $0 != nil && $1 != nil && ($2 ?? 0 > 0 || $3 ?? 0 > 0)
        }
    }
    
    var canUpload: Observable<Bool> {
    
        return Observable.combineLatest(firstStepDone, nameObservable, mailObservable) {
            return $0 && !($1?.isEmpty ?? true) && isValidEmail(testStr: $2 ?? "")
        }
    
    }
    
    func post() -> Observable<Offer?> {
        
        guard let i = image, let name = name, let mail = mail, let loc = location else {
            return Observable.just(nil)
        }
        
        let p: [String: Any] = [
            "Image": (UIImageJPEGRepresentation(i, 0.3) ?? Data()).byteArray,
            "Bag": bag,
            "Box": box,
            "Note": note,
            "Name": name,
            "Mail": mail,
            "Location": Location(location: loc).json
        ]
        
        return NetworkManager.shared.post(path: "/offers", params: p).map { Offer(json: $0) }
    }
    
}

func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

class CreateOfferVC: ViewController {

    let disposeBag = DisposeBag()
    
    let model = CreateOfferModel()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var amountTextField: UITextField! {
        didSet {
            amountTextField.delegate = self
            amountTextField.text = "0"
        }
    }
    @IBOutlet weak var boxButton: UIButton!
    @IBOutlet weak var bagButton: UIButton!
    @IBOutlet weak var noteLabel: UILabel!
    @IBAction func boxButtonPressed(_ sender: Any) {
        boxButton.isSelected = true
        bagButton.isSelected = false
        
    }
    @IBAction func bagButtonPressed(_ sender: Any) {
        boxButton.isSelected = false
        bagButton.isSelected = true
    }
    
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
            noteTextView.delegate = self
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
        
        title = "Create offer"
        
        model.imageObservable.bindTo(imageView.rx.image).addDisposableTo(disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .addDisposableTo(disposeBag)
        
        boxButton.isSelected = true
        
        amountTextField.rx.text.map {
            Int($0 ?? "") ?? 0
        }.subscribe(onNext: { [weak self] v in
            
            self?.model.box = self?.boxButton.isSelected ?? false ? v : 0
            self?.model.bag = self?.bagButton.isSelected ?? false ? v : 0
            
        }).addDisposableTo(self.disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GetLocation().get().subscribe(onNext: { [weak self] l in
            self?.model.location = l
        }).addDisposableTo(disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        model.note = noteTextView.text
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

extension CreateOfferVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        return Int(newString) != nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension CreateOfferVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "/n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
