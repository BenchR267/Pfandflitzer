//
//  NetworkManager.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import Foundation
import RxSwift

class NetworkManager {
    
    static let shared = NetworkManager()
    
    let baseUrl = "http://192.168.100.110:8764/api"
    
    func get(path: String, params: [String: String]) -> Observable<Any?> {
        
        let p = params.map { "\($0)=\($1)" }
        guard let url = URL(string: "\(baseUrl)\(path)?\(p.joined(separator: "&"))") else {
            return Observable.just(nil)
        }
        
        return URLSession.shared.rx.json(url: url).map { $0 as Any? }
    }
    
    func post(path: String, params: [String: Any]) -> Observable<Any?> {
        
        guard let u = URL(string: "\(baseUrl)\(path)") else {
            return Observable.just(nil)
        }
        let p = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        var r = URLRequest(url: u, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        r.httpBody = p
        r.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.rx.json(request: r).map { $0 as Any? }
    }
    
}
