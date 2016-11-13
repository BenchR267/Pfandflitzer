//
//  ShowOffersVC.swift
//  Pfandflitzer
//
//  Created by Benjamin Herzog on 12/11/2016.
//  Copyright © 2016 Benjamin Herzog. All rights reserved.
//

import UIKit
import RxSwift

class ShowOffersVC: ViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    
    var offers = [Offer]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: String(describing: OfferTVC.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: OfferTVC.self))
        
        GetLocation().get().subscribe(onNext: { l in
            let loc = Location(location: l!)
            Offer.get(location: loc).subscribe(onNext: { [weak self] o in
                self?.offers = o ?? []
            }).addDisposableTo(self.disposeBag)
        }).addDisposableTo(self.disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let d = segue.destination as? OfferDetailVC, let i = sender as? IndexPath {
            d.offer = offers[i.row]
        }
    }
}

extension ShowOffersVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: OfferTVC.self), for: indexPath) as! OfferTVC
        let o = offers[indexPath.row]
        cell.setup(offer: o)
        return cell
    }
    
}
