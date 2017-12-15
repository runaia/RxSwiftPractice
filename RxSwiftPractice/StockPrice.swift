//
//  StockPrice.swift
//  RxSwiftPractice
//
//  Created by seojiwon on 2017. 12. 15..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import Foundation
import RxSwift

class StockPrice {
    
    //MARK: - Properties
    public let symbol: String
    public var isFavorite: Bool = false
    
    private let price = Variable<Double>(0)
    var priceObservable: Observable<Double> {
        return price.asObservable()
    }
    
    
    //MARK: - Initializers
    init(symbol: String, favorite: Bool) {
        self.symbol = symbol
        self.isFavorite = favorite
    }
    
    func update(_ price: Double) {
        self.price.value = price
    }
}
