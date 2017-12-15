//
//  StockCell.swift
//  RxSwiftPractice
//
//  Created by seojiwon on 2017. 12. 15..
//  Copyright © 2017년 seojiwon. All rights reserved.
//

import UIKit

class StockCell: UITableViewCell {
    
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!
    
    func update(with: StockPrice) {
        
        var text = with.symbol
        if with.isFavorite { text += "❤️" }
        symbol.text = text
        
    }
    
}
