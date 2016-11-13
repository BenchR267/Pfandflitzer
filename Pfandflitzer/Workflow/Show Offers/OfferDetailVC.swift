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

class OfferAnnotation: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    let title: String?
    
    init(offer: Offer) {
        coordinate = offer.location.cl.coordinate
        title = offer.amountText()
    }
    
}

class OfferDetailVC: ViewController {

    var offer: Offer!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.kf.setImage(with: offer.imageURL, placeholder: UIImage(named: "camera"))
        amountLabel.text = offer.amountText()
        noteLabel.text = offer.note
        
        let a = OfferAnnotation(offer: offer)
        mapView.addAnnotation(a)
        
        let center = offer.location.cl
        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center.coordinate,
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
}
