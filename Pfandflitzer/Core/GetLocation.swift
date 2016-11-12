//
//  GetLocation.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class GetLocation {
    
    let locationManager = CLLocationManager()
    let disposeBag = DisposeBag()
    var strongSelf: GetLocation?
    
    func get() -> Observable<CLLocation?> {
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        strongSelf = self
        let location = locationManager.rx.didUpdateLocations.map {$0.first}
        location.subscribe { [weak self] l in
            self?.strongSelf = nil
        }.addDisposableTo(disposeBag)
        return location
    }
    
}
