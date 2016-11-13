//
//  OfferTVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import Kingfisher

private var dateF: DateFormatter = {
    $0.dateFormat = "EEEE hh:mm"
    $0.locale = Locale.current
    return $0
}(DateFormatter())

class OfferTVC: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.pictureView.image = nil
        self.distanceLabel.text = ""
        self.timeLabel.text = ""
        self.amountLabel.text = ""
    }
    
    func setup(offer: Offer) {
        self.pictureView.kf.setImage(with: offer.imageURL, placeholder: UIImage(named: "camera"))
        self.distanceLabel.text = offer.distance
        self.timeLabel.text = dateF.string(from: offer.creation)
        self.amountLabel.text = offer.amountText(spacer: "\n")
    }
    
}
