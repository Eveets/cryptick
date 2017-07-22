//
//  TickerManager.swift
//  cryptick
//
//  Created by Steeve Monniere on 20-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//
import Foundation

class TickerManager :NSObject {
    static let sharedInstance = TickerManager()
    
    var jsonURLScheme : String = "https://api.gdax.com/products/%@/ticker"
    var lastUpdated : Date?
    var tickers : Dictionary = [String:Ticker]()
    
    
    
    override init()
    {
        super.init()
        tickers["ETH-USD"] = Ticker.ticker(originCurrency: "ETH", destinationCurrency: "USD")
        tickers["BTC-USD"] = Ticker.ticker(originCurrency: "BTC", destinationCurrency: "USD")
        tickers["LTC-USD"] = Ticker.ticker(originCurrency: "LTC", destinationCurrency: "USD")
        tickers["ETH-BTC"] = Ticker.ticker(originCurrency: "ETH", destinationCurrency: "BTC")
    }
    
    func fetchAll()
    {
        var i = 0
        for  page in tickers.keys
        {
            let url = String.localizedStringWithFormat(self.jsonURLScheme, page)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(i/2), execute: {
                let jsonDict = self.fetch(url: url)
                self.tickers[page]?.ask = jsonDict["ask"] as? Int64
                self.tickers[page]?.bid = jsonDict["bid"] as? Int64
                self.tickers[page]?.price = jsonDict["price"] as? Int64
                self.tickers[page]?.volume = jsonDict["volume"] as? Int64
                self.tickers[page]?.trade_id = jsonDict["trade_id"] as? Int64
                self.tickers[page]?.size = jsonDict["size"] as? Int64
                self.tickers[page]?.time = jsonDict["time"] as? Date
            })
            i += 1
        }
        lastUpdated = Date.init(timeIntervalSinceNow: 0)
    }
    
    private func fetch(url:String) -> Dictionary<String, AnyObject>
    {
        //Fetch a the JSON object with the price list
        guard let jsonURL = URL(string: url) else {
            print("Error: doesn't seem to be a valid URL")
            return [:]
        }
        do {
            let jsonString = try String(contentsOf: jsonURL, encoding: .ascii)
            //print("JSON : \(jsonString)")
            return parseString(jsonString: jsonString)
        } catch let error {
            print("Error: \(error)")
            return [:]
        }
        
    }
    
    
    private func parseString(jsonString : String) -> Dictionary<String, AnyObject>
    {
        if let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, AnyObject>
                if(json != nil)
                {
                    print("Price for \(json?["price"] ?? "" as AnyObject)")
                    return json!;
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
 
            }
        }
        return [:]
    }

    
    
}
