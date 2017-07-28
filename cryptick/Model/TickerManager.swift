//
//  TickerManager.swift
//  cryptick
//
//  Created by Steeve Monniere on 20-07-2017.
//  Copyright © 2017 Steeve Monniere. All rights reserved.
//
import Foundation
import SwiftyJSON


class TickerManager :NSObject {
    static let sharedInstance = TickerManager()
    
    var pairsURL : String = "https://api.kraken.com/0/public/AssetPairs"
    var tickerURL : String = "https://api.kraken.com/0/public/Ticker?pair=%@"
    var lastUpdated : Date?
    var tickers : [Ticker] = []
    var tickerReady :Bool = false
    var fetching :Bool = false
    
    
    
    override init()
    {
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            let json = self.fetch(url: self.pairsURL)
            //print(json);
            
            for (key,value) in json["result"]
            {
                if(!key.contains(".d"))
                {
                    let t = Ticker.ticker(base: value["base"].stringValue, quote: value["quote"].stringValue)
                    
                    //TODO : Send to user for activation
                    if(t.base == "XXBT" || t.base == "XETH")
                    {
                        t.active = true
                    }
                    self.tickers.append(t)
                }
            }
            self.tickerReady = true
            let refreshTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(TickerManager.fetchAll), userInfo: nil, repeats: true)
            RunLoop.main.add(refreshTimer, forMode: RunLoopMode.defaultRunLoopMode)

            self.fetchAll()
        })
        
    }
    
    public func tickerWith(base:String, quote:String) -> Ticker?
    {
        for t in tickers
        {
            if(t.active && t.base == base && t.quote == quote)
            {
                return t
            }
        }
        return nil
    }
    
    func activeTicker(base:String) -> [Ticker]
    {
        var ret : [Ticker] = []
        for t in tickers
        {
            if(t.active && t.base == base)
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
                
                //Create the list of pairs we want to fetch
                var pairs:[String] = []
                for t in tickers
                {
                    if(t.active)
                    {
                        let pair = String.localizedStringWithFormat("%@%@", t.base!, t.quote!)
                        pairs.append(pair)
                    }
                }
                //Fetch the JSON feed for our pairs
                //Refresh only if it was not refreshed in the last 10 seconds
                if(lastUpdated == nil || now.isGreaterThanDate(dateToCompare: (lastUpdated?.addingTimeInterval(10))!))
                {
                    let pairString = pairs.joined(separator: ",")
                    let url = String.localizedStringWithFormat(self.tickerURL, pairString)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
                        self.fetching = true;
                        let json = self.fetch(url: url)
                        for (key, value) in json["result"]
                        {
                            let ticker = self.tickerWith(code: key)
                            ticker?.price = value["c"][0].doubleValue
                            ticker?.openPrice = value["o"].doubleValue
                            ticker?.low = value["l"][1].doubleValue
                            ticker?.high = value["h"][1].doubleValue
                            ticker?.volume = value["v"][1].doubleValue
                            ticker?.ask = value["a"][0].doubleValue
                            ticker?.bid = value["b"][0].doubleValue
                            print("Code : \(ticker!.base ?? "") - \(ticker!.quote ?? "") : \(ticker?.price ?? 0.0)");
                            
                        }
                        NotificationCenter.default.post(name: Notification.Name("com.chinchillasoft.tickerDataupdated"), object: nil)
                        self.fetching = false
                    })
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
            
            let json = JSON(data: data)
            return json
        }
        return JSON.null
    }

    private func tickerWith(code :String) -> Ticker?
    {
        let base = code.substring(to:4)
        let quote = code.substring(from: 4)
        
        for t in tickers
        {
            if(t.base == base && t.quote == quote){
                return t
            }
        }
        return nil
    }
    
}
