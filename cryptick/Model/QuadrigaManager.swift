//
//  QuadrigaManager.swift
//  cryptick
//
//  Created by Steeve Monniere on 20-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//
import Foundation
import SwiftyJSON


class QuadrigaManager :NSObject {
    static let sharedInstance = QuadrigaManager()
    
    var tickerURL : String = "https://api.quadrigacx.com/v2/ticker?book=%@"
    var lastUpdated : Date?
    var tickers : [Ticker] = []
    var tickerReady :Bool = false
    var fetching :Bool = false
    
    let pairs:[String] = ["btc_cad", "btc_usd", "eth_cad", "eth_btc","ltc_cad", "bch_cad", "btg_cad"]
    
    
    
    override init()
    {
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            
            for (key) in self.pairs
            {
                let base = key.split(separator: "_")[0]
                let quote = key.split(separator: "_")[1]
                let t = Ticker.ticker(base: String(base), quote: String(quote))
                self.tickers.append(t)
              
            }
            self.tickerReady = true
            let refreshTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(QuadrigaManager.fetchAll), userInfo: nil, repeats: true)
            RunLoop.main.add(refreshTimer, forMode: RunLoopMode.defaultRunLoopMode)
            self.fetchAll()
        })
        
    }
    
    public func tickerWith(base:String, quote:String) -> Ticker?
    {
        for t in tickers
        {
            if(t.base == base && t.quote == quote)
            {
                return t
            }
        }
        return nil
    }
    
    func activeTicker() -> [Ticker]
    {
        var ret : [Ticker] = []
        for t in tickers
        {
            if(t.active)
            {
                ret.append(t)
            }
        }
        return ret
    }
    
    
    func fetchAll()
    {
        if(!fetching)
        {
            if(tickerReady)
            {
                if(lastUpdated == nil) {
                    NotificationCenter.default.post(name: Notification.Name("com.chinchillasoft.startLoading"), object: nil)
                }
                
                let now = Date.now()
                
                //Fetch the JSON feed for our pairs
                //Refresh only if it was not refreshed in the last 10 seconds
                if(lastUpdated == nil || now.isGreaterThanDate(dateToCompare: (lastUpdated?.addingTimeInterval(10))!))
                {
                    for(pair) in self.pairs
                    {
                        let url = String.localizedStringWithFormat(self.tickerURL, pair)
                        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                            self.fetching = true;
                            let json = self.fetch(url: url)
                            
                            let ticker:Ticker? = self.tickerWith(code: pair)
                            var oldPrice:Double = 0.0
                            if(ticker != nil && ticker!.price != nil){
                                oldPrice = ticker!.price!
                            }
                            
                            
                            ticker?.price = json["last"].doubleValue
                            ticker?.vwap = json["vwap"].doubleValue
                            ticker?.low = json["low"].doubleValue
                            ticker?.high = json["high"].doubleValue
                            ticker?.volume = json["volume"].doubleValue
                            ticker?.ask = json["ask"].doubleValue
                            ticker?.bid = json["bid"].doubleValue
                            ticker?.active = true
                            if(oldPrice != 0.0 && oldPrice != ticker?.price!)
                            {
                                ticker?.unchanged = false;
                                ticker?.up = (ticker?.price!)! > oldPrice
                            }
                            else
                            {
                                ticker?.unchanged = true
                                ticker?.up = false
                            }
                            print("Code : \(ticker!.base ?? "") - \(ticker!.quote ?? "") : \(ticker?.price ?? 0.0)");
                            
                            
                            NotificationCenter.default.post(name: Notification.Name("com.chinchillasoft.tickerDataupdated"), object: nil)
                            self.fetching = false
                        })
                    }
                    
                }
                lastUpdated = Date.now()
            }
        }
    }
    
    private func fetch(url:String) -> JSON
    {
        //Fetch a the JSON object with the price list
        guard let jsonURL = URL(string: url) else {
            print("Error: doesn't seem to be a valid URL")
            NotificationCenter.default.post(name: Notification.Name("com.chinchillasoft.stopLoading"), object: nil)
            return JSON.null
        }
        do {
            let jsonString = try String(contentsOf: jsonURL, encoding: .ascii)
            //print("JSON : \(jsonString)")
            return parseString(jsonString: jsonString)
        } catch let error {
            print("Error: \(error)")
            NotificationCenter.default.post(name: Notification.Name("com.chinchillasoft.stopLoading"), object: error)
        }
        return JSON.null
        
    }
    
    
    private func parseString(jsonString : String) -> JSON
    {
        if let data = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            let json = try? JSON(data: data)
        
            
            return json!
        }
        return JSON.null
    }
    
    private func tickerWith(code :String) -> Ticker?
    {
        let base = String(code.split(separator: "_")[0])
        let quote = String(code.split(separator: "_")[1])
        
        for t in tickers
        {
            if(t.base == base && t.quote == quote){
                return t
            }
        }
        return nil
    }
    
}

