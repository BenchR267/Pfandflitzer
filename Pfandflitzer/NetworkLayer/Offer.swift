//
//  Offer.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

class Owner {
    
    let name: String
    let mail: String
    
    init?(json: Any?) {
        guard let j = json as? [String: Any] else {
            return nil
        }
        
        guard let name = j["Name"] as? String, let mail = j["Email"] as? String else {
            return nil
        }
        
        self.name = name
        self.mail = mail
    }
    
}

class Location {
    
    let latitude: Double
    let longitude: Double
    
    init?(json: Any?) {
        
        guard let j = json as? [String: Any] else {
            return nil
        }
        
        guard let lat = j["Latitude"] as? Double, let long = j["Longitude"] as? Double else {
            return nil
        }
        
        self.latitude = lat
        self.longitude = long
    }
    
    init(location: CLLocation) {
        self.longitude = location.coordinate.longitude
        self.latitude = location.coordinate.latitude
    }
    
    var json: [String: String] {
        return ["Latitude": "\(latitude)", "Longitude": "\(longitude)"]
    }
}

class Offer {
    
    let id: String
    let note: String
    let boxes: Double
    let bags: Double
    
    let owner: Owner
    let location: Location
    
    init?(json: Any?) {
        
        guard let j = json as? [String: Any] else {
            return nil
        }
        
        guard let id = j["Id"] as? String,
            let note = j["Note"] as? String,
            let boxes = j["Boxes"] as? Double,
            let bags = j["Bags"] as? Double else {
            
            return nil
        }
        
        self.id = id
        self.note = note
        self.boxes = boxes
        self.bags = bags
        
        guard let owner = Owner(json: j["Owner"]) else {
            return nil
        }
        
        self.owner = owner
        
        guard let loc = Location(json: j["Location"]) else {
            return nil
        }
        
        self.location = loc
    }
    
}

extension Offer {
    
    static func get(location: Location) -> Observable<[Offer]?> {
        return NetworkManager.shared.get(path: "/offers", params: location.json)
            .map { ($0 as? [Any])?.flatMap(Offer.init) }
    }
    
}
