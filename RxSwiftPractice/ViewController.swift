//
//  ViewController.swift
//  RxSwiftPractice
//
//  Created by seojiwon on 2017. 12. 15..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    // MARK: - Properties
    fileprivate let bag = DisposeBag()
    
    //input
    fileprivate let allSymbols = ["RZW", "UDP", "MTT", "ZKQ", "IPK", "KRW"]
    fileprivate let allPrices = Variable<[StockPrice]>([])
    
    //output
    fileprivate let prices = Variable<[StockPrice]>([])
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favoritesSwitch: UISwitch!
    @IBOutlet weak var searchTerm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initialize date
        allPrices.value = allSymbols.enumerated().map { index, symbol in
            return StockPrice(symbol: symbol, favorite: index % 2 == 0)
        }
        
        tableView.rowHeight = 50
        
        
        //bind UI
        bindUI()
    }


}


//MARK: - Internal
extension ViewController {
    
    func bindUI() {
        Observable.combineLatest(
            allPrices.asObservable(),
            favoritesSwitch.rx.isOn,
            searchTerm.rx.text,
            resultSelector: { currentPrices, onlyFavorites, search in
                
                //                print("\(currentPtices) \(onlyFavorites) \(search)")
                
                return currentPrices.filter { price -> Bool in
                    return shouldDisplayPrice(price: price,
                                              onlyFavorites: onlyFavorites,
                                              search: search)
                }
                
        })
            .bind(to: prices)
            .disposed(by: bag)
        
        prices.asObservable()
            .subscribe(onNext: { [weak self] value in
                self?.tableView.reloadData()
            })
            .disposed(by: bag)
    }
    
}

//MARK: - Table Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell") as! StockCell
        
        let price = prices.value[indexPath.row]
        cell.update(with: price)
        
        return cell
    }
}

// MARK: - Functions
fileprivate func shouldDisplayPrice(price: StockPrice, onlyFavorites: Bool, search: String?) -> Bool {
    if onlyFavorites && !price.isFavorite {
        return false
    }
    if let search = search,
        !search.isEmpty,
        !price.symbol.contains(search) {
        return false
    }
    return true
}
