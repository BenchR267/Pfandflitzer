//
//  OfferDetailVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import MapKit
import Kingfisher
import RxSwift

class OfferAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(offer: Offer) {
        coordinate = offer.location.cl.coordinate
        title = offer.amountText()
    }
    
}

class OfferDetailVC: ViewController {

    let disposeBag = DisposeBag()
    
    var offer: Offer!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel! {
        didSet {
            addressLabel.text = ""
        }
    }
    @IBOutlet weak var effectsView: UIVisualEffectView! {
        didSet {
            effectsView.isUserInteractionEnabled = true
            let g = UITapGestureRecognizer()
            g.rx.event.subscribe(onNext: { g in
                if let url = URL(string: "http://maps.apple.com/?ll=\(self.offer.location.latitude),\(self.offer.location.longitude)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }).addDisposableTo(self.disposeBag)
            effectsView.addGestureRecognizer(g)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = offer.distance
        
        imageView.kf.setImage(with: offer.imageURL, placeholder: UIImage(named: "camera"))
        amountLabel.text = offer.amountText()
        noteLabel.text = offer.owner.name + ": " + offer.note
        
        let a = OfferAnnotation(offer: offer)
        mapView.addAnnotation(a)
        
        let center = offer.location.cl
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        offer.location.address.bindTo(addressLabel.rx.text).addDisposableTo(self.disposeBag)
    }
    
}
