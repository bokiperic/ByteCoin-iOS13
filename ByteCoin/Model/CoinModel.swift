//
//  WeatherModel.swift
//  ByteCoin
//
//  Created by Bojan Peric on 3/6/23.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let currency: String
    let price: Double
    
    var priceString: String {
        return String(format: "%.2f", price)
    }
}
