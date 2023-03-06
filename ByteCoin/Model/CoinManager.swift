//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateLastPrice(_ coinManager: CoinManager, price: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "E4B8816E-9D84-4EDC-90C6-64619B03C580"
    
    var delegate: CoinManagerDelegate?
    
//  https://rest.coinapi.io/v1/exchangerate/BTC/USD?apiKey=E4B8816E-9D84-4EDC-90C6-64619B03C580
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let coin = self.parseJSON(safeData)
                    self.delegate?.didUpdateLastPrice(self, price: coin!)
                }
            }
            
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let currency = decodedData.asset_id_quote
            
            let coinPrice = CoinModel(currency: currency, price: lastPrice)
            
            return coinPrice
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
